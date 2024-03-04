    
from snowflake.snowpark.functions import udf
import pandas as pd


def date_max_snowflake(dbts,session):
    try: 
        date_max=session.sql(f"select max(sales_date) from {dbts.this}").collect()[0][0]
        return date_max
    except: 
        return session.sql("select to_date('28/02/2024','DD/MM/YYYY') as salesdates").collect()[0][0]
    
def model(dbt, session):
    # Must be either table or incremental (view is not currently supported)
    dbt.config(materialized = "incremental")
    dbt.config(database='INTERMEDIATE')
    dbt.config(schema='STAGE_LANDED')
    dbt.config(unique_key = 'SALES_ID')
    dbt.config(transient=False)
    

    # User defined function

    # DataFrame representing an upstream model
    df_catalog = session.sql("SELECT $1::number as Sales_ID,$2::varchar as Region,$3::varchar as Country,$4::varchar as Item_type, $5::varchar as Sales_type,$6::number as units_sold,$7::float as units_price, $8::float as unit_cost,$9::float as total_revenue,$10::float as total_cost,$11::float as total_profit,$12::date as sales_date,METADATA$FILENAME, METADATA$FILE_ROW_NUMBER,METADATA$FILE_LAST_MODIFIED FROM  @INTERMEDIATE.STAGE_LANDED.SALES_STAGE where $5 ='Offline' and METADATA$FILENAME not in (select file_name from INFO_MAINTAIN_DB.PUBLIC.INFORMATION_LOAD_FILE_STAGE_DB where TABLE_NAME='Offline Sales')").collect()
    dataframe_str_main=pd.DataFrame(df_catalog)
    if (len(dataframe_str_main)>0):
        max_from_this = date_max_snowflake(dbt,session)
        meta_file_info_frame=dataframe_str_main['METADATA$FILENAME'].unique()
        valid_dataframe_final=pd.DataFrame([])
        info_details_filename_count=pd.DataFrame([])
        for i in range(len(meta_file_info_frame)):
            meta_file_var=meta_file_info_frame[i]
            file_name_list={'FILE_NAME': [meta_file_var]}
            info_details_filename_count=pd.DataFrame(file_name_list)
            count_file_frame=session.sql(f"SELECT count(*) FROM @INTERMEDIATE.STAGE_LANDED.SALES_STAGE WHERE METADATA$FILENAME ='{meta_file_var}' and $5 ='Offline' ").collect()[0][0]
            date_file=session.sql(f"SELECT distinct METADATA$FILE_LAST_MODIFIED::date as sales_date  FROM @INTERMEDIATE.STAGE_LANDED.SALES_STAGE WHERE METADATA$FILENAME ='{meta_file_var}' and $5 ='Offline' ").collect()[0][0]
            valid_dataframe_1 = dataframe_str_main[(dataframe_str_main['SALES_DATE'] >= max_from_this)&(dataframe_str_main['METADATA$FILENAME']==meta_file_var)]
            invalid_Dataframe_1=dataframe_str_main[(dataframe_str_main['SALES_DATE'] < max_from_this)&(dataframe_str_main['METADATA$FILENAME']==meta_file_var)]
            valid_dataframe_2_not_null= valid_dataframe_1.dropna() #valid data final
            invalid_dataframe_2_null=valid_dataframe_1[valid_dataframe_1[['SALES_ID','REGION','COUNTRY','ITEM_TYPE','SALES_TYPE','UNITS_SOLD','UNITS_PRICE','UNIT_COST','TOTAL_REVENUE','TOTAL_COST','TOTAL_PROFIT','SALES_DATE']].isnull().any(axis=1)]
            frame_list=[invalid_Dataframe_1,invalid_dataframe_2_null]
            invalid_Dataframe_grp=pd.concat(frame_list)
            invalid_Dataframe_grp.insert(0,"file_name_blob",meta_file_var)
            info_details_filename_count.insert(1,"ROW_COUNT_INFILE",count_file_frame)
            # info_details_filename_count.insert(1,"FILE_NAME",meta_file_var)
            # info_details_filename_count.insert(2,"UPLOADED_DATE",date_file)
            len_valid=len(valid_dataframe_2_not_null)
            info_details_filename_count.insert(2,"COUNT_VALID_ROW",len_valid)
            len_invalid=len(invalid_Dataframe_grp)
            info_details_filename_count.insert(3,"INVALID_ROW_COUNT",len_invalid)
            info_details_filename_count.insert(4,"TABLE_NAME",'Offline Sales')
            # info_details_filename_count['UPLOADED_DATE'] = pd.to_datetime(info_details_filename_count['UPLOADED_DATE'])
            session.write_pandas(info_details_filename_count,'INFORMATION_LOAD_FILE_STAGE_DB',database="INFO_MAINTAIN_DB",schema="PUBLIC", auto_create_table=True,overwrite=False,table_type="transient")
            
            if (len(invalid_Dataframe_grp)>0):
                session.write_pandas(invalid_Dataframe_grp,f'INVALID_DATA_{meta_file_var}',database="INTERMEDIATE",schema="INVALID_DATA", auto_create_table=True,overwrite=True,table_type="transient")
            valid_dataframe_final=pd.concat([valid_dataframe_final,valid_dataframe_2_not_null])
        snowpark_dataframe=session.create_dataframe(valid_dataframe_final)
        return snowpark_dataframe
    else:
        # dataframe_str_main=dataframe_str_main[dataframe_str_main[['Sales_ID','REGION','COUNTRY','ITEM_TYPE','SALES_TYPE','UNITS_SOLD','UNITS_PRICE','UNIT_COST','TOTAL_REVENUE','TOTAL_COST','TOTAL_PROFIT','SALES_DATE']].any()]
        snowpark_dataframe=session.create_dataframe( df_catalog )
    return snowpark_dataframe



