select min(unix_timestamp(created_at)), max(unix_timestamp(created_at)), max(unix_timestamp(created_at)) - min(unix_timestamp(created_at)) as time_between
    > from session
    > where user_id = 10011510
    > and session_id = 'b4be485e-cc30-44e3-8b59-7ff4a941a628';

