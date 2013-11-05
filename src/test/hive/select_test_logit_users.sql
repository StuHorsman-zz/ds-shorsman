use movies;
select * 
from (
  select user_id, user_type
  from parental_controls
  where new = 'kid'
  union all
  select user_id, 0 as user_type
  from account_actions
  where type = 'updatePaymentInfo'
) union_result;
