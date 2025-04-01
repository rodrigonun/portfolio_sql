SELECT
    hotel_name,
    reviewer_score,
    count(reviewer_score)
FROM hotel_reviews

where hotel_name='Hotel Arena'

group by 1,2