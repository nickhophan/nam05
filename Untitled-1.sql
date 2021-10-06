<code>SELECT l.neighbourhood_group_cleansed, strftime('%m', date) as months, COUNT(c.available) as bookings 
    FROM calendar_summary c LEFT JOIN listings_summary l ON c.listing_id == l.id 
    WHERE c.available == 'f' 
    GROUP BY l.neighbourhood_group_cleansed 
    ORDER BY bookings DESC
    
    SELECT l.neighbourhood_group_cleansed, strftime('%m', date) as months, round(avg(substr(l.price,2)),2) AS price
    FROM calendar_summary c LEFT JOIN listings_summary l ON c.listing_id == l.id 
    WHERE l.neighbourhood_group_cleansed IN ('Friedrichshain-Kreuzberg','Mitte') and c.available = 'f'
    GROUP BY l.neighbourhood_group_cleansed, months
    
    SELECT strftime('%m', date) as months, round(SUM(substr(l.price,2)),2) AS value_revenue, COUNT(c.available) as bookings
    FROM calendar_summary c LEFT JOIN listings_summary l ON c.listing_id == l.id 
    WHERE c.available == 'f' 
    GROUP BY months
    ORDER BY bookings desc
    
    SELECT l.neighbourhood_group_cleansed, strftime('%m', date) as months, COUNT(c.available) as availability,  SUM(round(substr(l.price,2),2)) AS loss
    FROM calendar_summary c LEFT JOIN listings_summary l ON c.listing_id == l.id 
    WHERE c.available == 'f' 
    GROUP BY l.neighbourhood_group_cleansed, months
    ORDER BY loss DESC
    
    
    SELECT l.neighbourhood_group_cleansed, COUNT(c.available) as availability
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE c.available == 't' 
    GROUP BY l.neighbourhood_group_cleansed 
    ORDER BY availability DESC;
    
    SELECT strftime('%m', date) as months, strftime('%d', date) as days, COUNT(listing_id) AS total_rooms
    FROM calendar_summary 
    WHERE c.available == 't'
    GROUP BY months, days
    
    SELECT l.neighbourhood_group_cleansed, COUNT(c.available) as availability, strftime('%m', date) as months
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE c.available == 't' AND months = '01'
    GROUP BY l.neighbourhood_group_cleansed 
    ORDER BY availability DESC;
    
    SELECT strftime('%m', date) as months, COUNT(l.id) as instant_book
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE instant_bookable == 'f'
    GROUP BY months 
    ORDER BY instant_book DESC;
    
    SELECT strftime('%m', date) as months, COUNT(l.id) as instant_book
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE instant_bookable == 'f'
    GROUP BY months
    
    SELECT A.incorrect_location, B.picture_null, C.thumbnail_null, D.policy_null, E.response_info_null, F.host_identify_null
    FROM
    (
    SELECT COUNT(id) as incorrect_location
    FROM listings_summary
    WHERE is_location_exact =='f'
    ) A,
    (
    SELECT COUNT(id) as picture_null
    FROM listings_summary
    WHERE picture_url IS NULL
    ) B,
    (
    SELECT COUNT(id) as thumbnail_null
    FROM listings_summary
    WHERE thumbnail_url IS NULL
    ) C,
    (
    SELECT COUNT(id) as policy_null
    FROM listings_summary
    WHERE cancellation_policy IS NULL
    
    ) D,
    (
    SELECT COUNT(id) as response_info_null
    FROM listings_summary
    WHERE host_response_time IS NULL
    
    ) E,
    (
    SELECT COUNT(id) as host_identify_null
    FROM listings_summary
    WHERE host_identity_verified == 'f'
    
    ) F;
    
    SELECT neighbourhood_group_cleansed, CASE 
    WHEN maximum_nights < 180 THEN 'Less than 3 Months'
    WHEN maximum_nights >= 180 AND maximum_nights < 360 THEN '6 Months'
    WHEN maximum_nights >= 360 AND maximum_nights < 720 THEN '1 year'
    WHEN maximum_nights >= 720 AND maximum_nights < 1080 THEN '2 years'
    WHEN maximum_nights >= 1080 AND maximum_nights < 1081 THEN '3 years'
    ELSE 'More than 3 years' END as terms, COUNT(id) as locations
    FROM listings_summary
    WHERE maximum_nights IS NOT NULL
    GROUP BY neighbourhood_group_cleansed, terms;
    
    SELECT CASE 
    WHEN maximum_nights < 180 THEN 'Less than 3 Months'
    WHEN maximum_nights >= 180 AND maximum_nights < 360 THEN '6 Months'
    WHEN maximum_nights >= 360 AND maximum_nights < 720 THEN '1 year'
    WHEN maximum_nights >= 720 AND maximum_nights < 1080 THEN '2 years'
    WHEN maximum_nights >= 1080 AND maximum_nights < 1081 THEN '3 years'
    ELSE 'More than 3 years' END as terms, COUNT(id) as locations
    FROM listings_summary
    GROUP BY terms;
    
    SELECT A.months, A.policy, A.hosts, B.room_available FROM
    (SELECT  strftime('%m', date) as months, l.cancellation_policy as policy, COUNT(l.id) as hosts
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    GROUP BY months, policy) A,
    (SELECT COUNT(listing_id) as room_available 
    FROM calendar_summary
    WHERE available == 't'
    GROUP BY strftime('%m', date)) B;
    
    SELECT A.months, A.policy, A.room_available, B.total_rooms, (B.total_rooms - A.room_available) as available_rate FROM
    (SELECT strftime('%m', date) as months, l.cancellation_policy as policy, COUNT(l.id) as room_available
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE c.available == 't'
    GROUP BY months,policy) A,
    
    (SELECT strftime('%m', date) as month, COUNT(listing_id) as total_rooms 
    FROM calendar_summary
    GROUP BY month) B
    WHERE A.months == B.month
    GROUP BY A.months, A.policy ;
    
    SELECT strftime('%m', date) as month, ROUND(avg(substr(l.price,2))) as avg_price
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE l.neighbourhood_group_cleansed == 'Mitte'
    GROUP BY neighbourhood_group_cleansed, month
    
    SELECT strftime('%m', date) as month, COUNT(l.id) as available_rooms
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE l.neighbourhood_group_cleansed == 'Mitte' AND c.available =='t'
    GROUP BY neighbourhood_group_cleansed, month
    
    SELECT A.month,  CASE 
    WHEN A.day == '0' THEN 'Sunday'
    WHEN A.day == '1' THEN 'Monday' 
    WHEN A.day == '2' THEN 'Tuesday'
    WHEN A.day == '3' THEN 'Wednesday'
    WHEN A.day == '4' THEN 'Thursday'
    WHEN A.day == '5' THEN 'Friday'
    WHEN A.day == '6' THEN 'Saturday' END AS day_of_week, A.bookings
    
    FROM
    (SELECT strftime('%m', date) as month, strftime('%w', date) as day, COUNT(l.id) as bookings
    FROM calendar_summary c LEFT JOIN listings_summary l ON l.id == c.listing_id 
    WHERE c.available =='f'
    GROUP BY month, day) A
    </code>