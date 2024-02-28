with external_stage as(
SELECT SUM($12) as sum1 from @sales_stage where $4 = 'Offline'
),
stage_schema as(
    select sum(TOTAL_REVENUE) as sum2 FROM OFFLINE_SALES
),
final as(
    select t1.sum1 as stage_sum,t2.sum2  as table_sum from external_stage t1 join stage_schema t2
)
select * from final where stage_sum != table_sum
