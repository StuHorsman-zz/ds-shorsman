use movies;
drop table if exists test_users;
create table test_users (user_id INT, user_type INT);
insert into table test_users
select user_id, user_type
from parental_controls
where new = 'kid';
insert into table test_users
select user_id, 0 as user_type
from account_actions
where type = 'updatePaymentInfo';
