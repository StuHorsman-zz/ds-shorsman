USE movies;
SELECT a.session_id, a.count as Account, b.count as AddToQueue
FROM session s JOIN session b ON s.session_id = b.session_id;
