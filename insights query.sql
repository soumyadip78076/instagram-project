use ig_clone;

#Loyal User Reward
select * from users 
order by created_at asc limit 5;

----------------------------------

#Inactive User Engagement
select users.id, users.username, users.created_at from users
left join photos 
on users.id=photos.user_id
where image_url is null;

----------------------------------------------

#Contest Winner Declaration
select users.id as users_id,users.username as user_name,users.created_at,photos.id as photo_id,photos.image_url,count(likes.photo_id) as total_like from photos
inner join users on photos.user_id=users.id
inner join likes on photos.id=likes.photo_id
group by photos.id,users.id
order by total_like desc
limit 3;

-------------------------------------------------

#Hashtag Research
select tags.tag_name,count(tags.id) as max_tags from photo_tags
inner join tags on photo_tags.tag_id=tags.id
inner join photos on photo_tags.photo_id=photos.id
group by tag_name
order by max_tags desc
limit 5;

--------------------------------------------------------

#Ad Campaign Launch
select distinct dayname(created_at) as day_name,count(dayname(created_at)) as max_count_of_day from users
group by day_name 
order by max_count_of_day desc;


select distinct dayname(created_at) as day_name,hour(created_at) as hour_time,count(hour(created_at)) as max_count_of_the_particler_hour from users
group by day_name,hour_time
having day_name in ("Thursday","Sunday");

----------------------------------------------

#User Engagement
/*in the case where many user posted photo at multiple times*/ /*OUTPUT IS 2.5700 */
select
(select count(image_url) from photos)/(select count(username) from users) as average_no_posts; 

/*in the case of total photos / total no of user */  /*OUTPUT IS 3.4730 */
select (count(photos.image_url) /count(distinct users.username)) as avg_no_post_per_user from photos
inner join users on photos.user_id=users.id;

/*We can Write the two query in a single query also */
SELECT
    (SELECT COUNT(image_url) FROM photos) / (SELECT COUNT(username) FROM users) AS average_no_of_post,
    COUNT(photos.image_url) / COUNT(DISTINCT users.username) AS avg_no_post_per_user
FROM photos
INNER JOIN users ON photos.user_id = users.id;

------------------------------------------------------------

#Bots & Fake Accounts
SELECT users.id,users.username from users
inner join likes on users.id=likes.user_id
group by users.id,users.username
having count(likes.photo_id)=(select count(*) from photos);

----------------------------------------------------

/*which user posted photo multiple times*/
select users.id as id_no,users.username,count(image_url) from photos
inner join users on photos.user_id=users.id
group by id_no
order by count(image_url) desc;