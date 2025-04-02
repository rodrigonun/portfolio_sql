
SELECT
    DISTINCT
    t1.*
from facebook_posts as t1

LEFT JOIN facebook_reactions as t2
ON t1.post_id=t2.post_id

WHERE t2.reaction = 'heart'



