use capstone_project;
-- 1. Relationship between attendance and events like goals or cards
SELECT 
    attendance,
    SUM(goals) AS total_goals,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards,
    COUNT(DISTINCT game_id) AS number_of_games
FROM my_table
GROUP BY attendance
ORDER BY attendance;
-- 2. Trends in frequency of goals, assists, and cards over seasons, competition types, or rounds
SELECT
    season,
    competition_type,
    round,
    SUM(goals) AS total_goals,
    SUM(assists) AS total_assists,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards
FROM my_table
GROUP BY season, competition_type, round
ORDER BY season, competition_type, round;
-- 3. Player events before and after contract expiration (assuming you track transfer dates elsewhere)
SELECT 
    player_id,
    CASE 
        WHEN date_x <= contract_expiration_date THEN 'Before Expiry'
        ELSE 'After Expiry'
    END AS period,
    SUM(goals) AS total_goals,
    SUM(assists) AS total_assists,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards
FROM my_table
WHERE contract_expiration_date IS NOT NULL AND date_x IS NOT NULL
GROUP BY player_id, period;
-- 4. Impact top ten player on goals or cards in a match
SELECT 
    player_id,
    SUM(goals) AS total_goals,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards
FROM my_table
GROUP BY player_id
ORDER BY total_goals DESC
LIMIT 10;
-- analyze their impact on matches individually (goals/cards per match for those top ten players
WITH TopPlayers AS (
    SELECT player_id
    FROM my_table
    GROUP BY player_id
    ORDER BY SUM(goals) DESC
    LIMIT 10
)
SELECT 
    ge.game_id,
    ge.player_id,
    SUM(ge.goals) AS goals_by_player,
    SUM(ge.yellow_cards) AS yellow_cards_by_player,
    SUM(ge.red_cards) AS red_cards_by_player
FROM my_table ge
JOIN TopPlayers tp ON ge.player_id = tp.player_id
GROUP BY ge.game_id, ge.player_id
ORDER BY tp.player_id, ge.game_id;




