CREATE TABLE Clan (
    ClanID INT PRIMARY KEY,
    ClanName VARCHAR(100) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    CreatedOn DATE NOT NULL,
    LeaderID INT
);

CREATE TABLE Admin (
    AdminID INT PRIMARY KEY,
    AdminName VARCHAR(100) NOT NULL,
    AssignDate DATE NOT NULL,
    E_mail VARCHAR(100),
    Role VARCHAR(50) NOT NULL
);

CREATE TABLE Player (
    PlayerID INT PRIMARY KEY,
    PlayerName VARCHAR(100) NOT NULL,
    E_mail VARCHAR(100),
    TotalDeaths INT NOT NULL,
    Exp INT,
    TotalKills INT NOT NULL,
    Level INT,
    Rank VARCHAR(50),
    HeadShots INT NOT NULL,
    Region VARCHAR(50) NOT NULL,
    JoinDate DATE NOT NULL,
    ClanID INT,
    AdminID INT NOT NULL,
    FOREIGN KEY (ClanID) REFERENCES Clan(ClanID),
    FOREIGN KEY (AdminID) REFERENCES Admin(AdminID)
);

ALTER TABLE Clan
ADD CONSTRAINT fk_clan_leader
FOREIGN KEY (LeaderID) REFERENCES Player(PlayerID);

CREATE TABLE Vehicle (
    VehicleID INT PRIMARY KEY,
    VehicleName VARCHAR(100) NOT NULL,
    VehicleType VARCHAR(50) NOT NULL,
    MaxSpeed INT NOT NULL,
    Capacity INT NOT NULL,
    FuelCapacity INT NOT NULL,
    Durability INT NOT NULL
);

CREATE TABLE Season (
    SeasonID INT PRIMARY KEY,
    SeasonName VARCHAR(100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    SeasonTheme VARCHAR(100)
);

CREATE TABLE GameMode (
    ModeID INT PRIMARY KEY,
    ModeName VARCHAR(100) NOT NULL,
    MaxPlayers INT NOT NULL,
    Description TEXT,
    TeamSize INT NOT NULL
);

CREATE TABLE Map (
    MapID INT PRIMARY KEY,
    MapName VARCHAR(100) NOT NULL,
    Terrain VARCHAR(50)
);

CREATE TABLE Weapon (
    WeaponID INT PRIMARY KEY,
    WeaponName VARCHAR(100) NOT NULL,
    Type VARCHAR(50),
    Damage INT NOT NULL,
    FireRate INT NOT NULL
);

CREATE TABLE Match (
    MatchID INT PRIMARY KEY,
    Mode VARCHAR(50) NOT NULL,
    MatchType VARCHAR(50) NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    MapID INT NOT NULL,
    AdminID INT NOT NULL,
    SeasonID INT NOT NULL,
    ModelID INT NOT NULL,
    FOREIGN KEY (MapID) REFERENCES Map(MapID),
    FOREIGN KEY (AdminID) REFERENCES Admin(AdminID),
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    FOREIGN KEY (ModelID) REFERENCES GameMode(ModeID)
);

CREATE TABLE Available_In (
    MapID INT NOT NULL,
    WeaponID INT NOT NULL,
    PRIMARY KEY (MapID, WeaponID),
    FOREIGN KEY (MapID) REFERENCES Map(MapID),
    FOREIGN KEY (WeaponID) REFERENCES Weapon(WeaponID)
);

CREATE TABLE Participates (
    MatchID INT NOT NULL,
    PlayerID INT NOT NULL,
    Kills INT NOT NULL,
    Deaths INT NOT NULL,
    DamageDealt INT NOT NULL,
    SurvivalTime INT NOT NULL,
    FinalRank INT NOT NULL,
    PRIMARY KEY (MatchID, PlayerID),
    FOREIGN KEY (MatchID) REFERENCES Match(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID)
);

CREATE TABLE UsesWeapon (
    MatchID INT NOT NULL,
    PlayerID INT NOT NULL,
    WeaponID INT NOT NULL,
    Accuracy INT,
    Headshots INT NOT NULL,
    PRIMARY KEY (MatchID, PlayerID, WeaponID),
    FOREIGN KEY (MatchID, PlayerID) REFERENCES Participates(MatchID, PlayerID),
    FOREIGN KEY (WeaponID) REFERENCES Weapon(WeaponID)
);

CREATE TABLE Available_On (
    VehicleID INT NOT NULL,
    MapID INT NOT NULL,
    Spawn_Rate INT NOT NULL,
    PRIMARY KEY (VehicleID, MapID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
    FOREIGN KEY (MapID) REFERENCES Map(MapID)
);

CREATE TABLE Spawns_At (
    VehicleID INT NOT NULL,
    MapID INT NOT NULL,
    Spawn_Location VARCHAR(100) NOT NULL,
    PRIMARY KEY (VehicleID, MapID, Spawn_Location),
    FOREIGN KEY (VehicleID, MapID) REFERENCES Available_On(VehicleID, MapID)
);

CREATE TABLE Ranks_in (
    PlayerID INT NOT NULL,
    SeasonID INT NOT NULL,
    Seasonal_Rank VARCHAR(50),
    Season_Points INT,
    Matches_Played INT,
    PRIMARY KEY (PlayerID, SeasonID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID)
);

CREATE TABLE Wallet (
    PlayerID INT NOT NULL,
    CreatedAt DATE NOT NULL,
    CoinBalance INT NOT NULL,
    PRIMARY KEY (PlayerID, CreatedAt),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID)
);