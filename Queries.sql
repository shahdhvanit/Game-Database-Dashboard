1.Find KD ratio (Kills/Deaths) for each player: 
SELECT  
    PlayerID, 
    PlayerName, 
    TotalKills, 
    TotalDeaths, 
    TotalKills::DECIMAL / TotalDeaths AS KD_Ratio 
FROM Player 
order by KD_Ratio desc; 


2.Find winner for every match: 
SELECT  
    p.PlayerName, 
    p.PlayerID, 
    pa.* 
FROM Participates pa 
JOIN Player p  
    ON pa.PlayerID = p.PlayerID 
WHERE pa.finalrank = 1 
order by pa.matchid;


3.For every admin, calculate workload: total number of players managed and total number of matches managed. 
SELECT  
    a.AdminID, 
    a.AdminName, 
    (SELECT COUNT(*)  
     FROM Player p  
     WHERE p.AdminID = a.AdminID) AS TotalPlayers, 
    (SELECT COUNT(*)  
     FROM Match m  
     WHERE m.AdminID = a.AdminID) AS TotalMatches 
FROM Admin a; 


4.Find the player with the highest kills in each match. 
SELECT  
    pa.MatchID, 
    pa.PlayerID, 
    p.PlayerName, 
    pa.Kills 
FROM Participates pa 
JOIN Player p  
    ON pa.PlayerID = p.PlayerID 
WHERE pa.Kills = ( 
    SELECT MAX(pa2.Kills) 
    FROM Participates pa2 
    WHERE pa2.MatchID = pa.MatchID 
); 


5.Retrieve the top 5 players based on total kills. 
SELECT  
    PlayerID, 
    PlayerName, 
    TotalKills 
FROM Player 
ORDER BY TotalKills DESC 
LIMIT 5; 


6.Calculate the average kills per match. 
SELECT  
    MatchID, 
    AVG(Kills) AS AvgKills 
FROM Participates 
GROUP BY MatchID 
ORDER BY MatchID; 


7.favorite gun for each player: 
SELECT  
    t.PlayerID, 
    p.PlayerName, 
    w.WeaponName 
FROM ( 
    SELECT  
        PlayerID, 
        WeaponID, 
        SUM(Accuracy) AS TotalAccuracy 
    FROM UsesWeapon 
    GROUP BY PlayerID, WeaponID 
) t 
JOIN Player p  
    ON t.PlayerID = p.PlayerID 
JOIN Weapon w  
    ON t.WeaponID = w.WeaponID 
WHERE t.TotalAccuracy = ( 
    SELECT MAX(t2.TotalAccuracy) 
    FROM ( 
        SELECT  
            PlayerID, 
            WeaponID, 
            SUM(Accuracy) AS TotalAccuracy 
        FROM UsesWeapon 
        GROUP BY PlayerID, WeaponID 
    ) t2 
    WHERE t2.PlayerID = t.PlayerID 
) 
order by playerID; 


8.leaderboard ordered by Season_Points: 
SELECT  
    r.SeasonID, 
    r.PlayerID, 
    p.PlayerName, 
    r.Season_Points 
FROM Ranks_in r 
JOIN Player p  
    ON r.PlayerID = p.PlayerID 
ORDER BY  
    r.SeasonID, 
    r.Season_Points DESC; 


9.Create an ordered list of wallets based on CoinBalance. 
SELECT  
    PlayerID, 
    CreatedAt, 
    CoinBalance 
FROM Wallet 
ORDER BY CoinBalance DESC; 


10.find rank of players based on accuracy for each weapon: 
SELECT  
    w.WeaponID, 
    w.WeaponName, 
    p.PlayerID, 
    p.PlayerName, 
    t.TotalAccuracy 
FROM ( 
    SELECT  
        PlayerID, 
        WeaponID, 
        SUM(Accuracy) AS TotalAccuracy 
    FROM UsesWeapon 
    GROUP BY PlayerID, WeaponID 
) t 
JOIN Player p ON t.PlayerID = p.PlayerID 
JOIN Weapon w ON t.WeaponID = w.WeaponID 
WHERE t.TotalAccuracy = ( 
    SELECT MAX(t2.TotalAccuracy) 
    FROM ( 
        SELECT  
            PlayerID, 
            WeaponID, 
            SUM(Accuracy) AS TotalAccuracy 
        FROM UsesWeapon 
        GROUP BY PlayerID, WeaponID 
    ) t2 
    WHERE t2.WeaponID = t.WeaponID 
); 


11.Make an ordered but unranked list of clans based on total experience (Exp) of their players. 
SELECT  
    c.ClanID, 
    c.ClanName, 
    SUM(p.Exp) AS TotalExp 
FROM Clan c 
JOIN Player p  
    ON c.ClanID = p.ClanID 
GROUP BY c.ClanID, c.ClanName 
ORDER BY TotalExp DESC; 


12.Make a list of vehicles sorted by maximum speed. 
SELECT  
    VehicleID, 
    VehicleName, 
    MaxSpeed 
FROM Vehicle 
ORDER BY MaxSpeed DESC; 


13.Find players who have higher than average experience (Exp): 
SELECT  
    PlayerID, 
    PlayerName, 
    Exp 
FROM Player 
WHERE Exp > ( 
    SELECT AVG(Exp) 
    FROM Player 
); 


14.Find Players with no performance drop (monotonic increase): 
SELECT DISTINCT p1.PlayerID as "players with no performance drop" 
FROM Participates p1 
WHERE NOT EXISTS ( 
    SELECT 1 
    FROM Participates p2 
    WHERE p2.PlayerID = p1.PlayerID 
    AND p2.MatchID > p1.MatchID 
    AND p2.Kills < p1.Kills 
); 


15.Find players whose kills are less than 20% of match total: 
SELECT  
    pa.PlayerID, 
    pa.MatchID, 
    pa.Kills 
FROM Participates pa 
WHERE pa.Kills < ( 
    SELECT SUM(Kills) * 0.2 
    FROM Participates p2 
    WHERE p2.MatchID = pa.MatchID 
); 


16.For every weapon, find the player with the most headshots. 
SELECT  
    w.WeaponID, 
    w.WeaponName, 
    p.PlayerID, 
    p.PlayerName, 
    t.TotalHeadshots 
FROM ( 
    SELECT  
        PlayerID, 
        WeaponID, 
        SUM(Headshots) AS TotalHeadshots 
    FROM UsesWeapon 
    GROUP BY PlayerID, WeaponID 
) t 
JOIN Player p ON t.PlayerID = p.PlayerID 
JOIN Weapon w ON t.WeaponID = w.WeaponID 
WHERE t.TotalHeadshots = ( 
    SELECT MAX(t2.TotalHeadshots) 
    FROM ( 
        SELECT  
            PlayerID, 
            WeaponID, 
            SUM(Headshots) AS TotalHeadshots 
        FROM UsesWeapon 
        GROUP BY PlayerID, WeaponID 
    ) t2 
    WHERE t2.WeaponID = t.WeaponID 
); 
