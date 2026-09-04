
--creating a database
CREATE DATABASE RaceDay;
USE RaceDay;


--creating tables if they exist drop them first
IF OBJECT_ID('dbo.Result', 'U') IS NOT NULL DROP TABLE dbo.Result;
IF OBJECT_ID('dbo.Enrollment', 'U') IS NOT NULL DROP TABLE dbo.Enrollment;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID('dbo.Event', 'U') IS NOT NULL DROP TABLE dbo.Event;
IF OBJECT_ID('dbo.Participant', 'U') IS NOT NULL DROP TABLE dbo.Participant;
IF OBJECT_ID('dbo.Organizer', 'U') IS NOT NULL DROP TABLE dbo.Organizer;
IF OBJECT_ID('dbo.Venue', 'U') IS NOT NULL DROP TABLE dbo.Venue;



-- 1. Organizer

CREATE TABLE dbo.Organizer (
    OrganizerID     INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(100)   NOT NULL,
    Surname         NVARCHAR(100)   NOT NULL,
    EmailAddress    NVARCHAR(150)   NOT NULL,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    CONSTRAINT UQ_Organizer_Email UNIQUE (EmailAddress)
);

-- 2. Participant

CREATE TABLE dbo.Participant (
    ParticipantID   INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(100)   NOT NULL,
    Surname         NVARCHAR(100)   NOT NULL,
    EmailAddress    NVARCHAR(150)   NOT NULL,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    CONSTRAINT UQ_Participant_Email UNIQUE (EmailAddress)
);



-- 3. Venue

CREATE TABLE dbo.Venue (
    VenueID         INT IDENTITY(1,1) PRIMARY KEY,
    VenueName       NVARCHAR(150)   NOT NULL,
    VenueAddress    NVARCHAR(200)   NOT NULL,
    VenueLocation   NVARCHAR(150)   NOT NULL
);

-- 4. Event
--    Owned by one Organizer, hosted at one Venue.

CREATE TABLE dbo.Event (
    EventID         INT IDENTITY(1,1) PRIMARY KEY,
    EventName       NVARCHAR(150)   NOT NULL,
    EventDate       DATE            NOT NULL,
    OrganizerID     INT             NOT NULL,
    VenueID         INT             NOT NULL,
    CONSTRAINT FK_Event_Organizer FOREIGN KEY (OrganizerID)
        REFERENCES dbo.Organizer (OrganizerID),
    CONSTRAINT FK_Event_Venue FOREIGN KEY (VenueID)
        REFERENCES dbo.Venue (VenueID)
);



-- 5. Category


CREATE TABLE dbo.Category (
    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName    NVARCHAR(100)   NOT NULL,
    EventID         INT             NOT NULL,
    CONSTRAINT FK_Category_Event FOREIGN KEY (EventID)
        REFERENCES dbo.Event (EventID),
    CONSTRAINT UQ_Category_EventName UNIQUE (EventID, CategoryName)
);



-- 6. Enrollment


CREATE TABLE dbo.Enrollment (
    EnrollmentID    INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID   INT             NOT NULL,
    CategoryID      INT             NOT NULL,
    DateRegistered  DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Enrollment_Participant FOREIGN KEY (ParticipantID)
        REFERENCES dbo.Participant (ParticipantID),
    CONSTRAINT FK_Enrollment_Category FOREIGN KEY (CategoryID)
        REFERENCES dbo.Category (CategoryID),
    CONSTRAINT UQ_Enrollment_ParticipantCategory UNIQUE (ParticipantID, CategoryID)
);


CREATE TABLE dbo.Result (
    ResultID        INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID    INT             NOT NULL,
    FinishTime      TIME            NULL,
    Position        INT             NULL,
    CONSTRAINT FK_Result_Enrollment FOREIGN KEY (EnrollmentID)
        REFERENCES dbo.Enrollment (EnrollmentID),
    CONSTRAINT UQ_Result_Enrollment UNIQUE (EnrollmentID),
    CONSTRAINT CK_Result_Position CHECK (Position IS NULL OR Position > 0)
);



--INSERTING VALUES


-- Organizers

INSERT INTO dbo.Organizer (Name, Surname, EmailAddress, PasswordHash)
VALUES
    ('Thabo',    'Nkosi',    'thabo.nkosi@raceday.co.za',     'HASHED_PWD_1'),
    ('Lindiwe',  'Mokoena',  'lindiwe.mokoena@raceday.co.za', 'HASHED_PWD_2');


-- Participants
INSERT INTO dbo.Participant (Name, Surname, EmailAddress, PasswordHash)
VALUES
    ('Sipho',  'Dlamini', 'sipho.dlamini@example.com', 'HASHED_PWD_3'),
    ('Ayesha', 'Patel',   'ayesha.patel@example.com',  'HASHED_PWD_4');



-- Venues

INSERT INTO dbo.Venue (VenueName, VenueAddress, VenueLocation)
VALUES
    ('FNB Stadium',      '1 Nasrec Rd, Nasrec',            'Soweto, Johannesburg'),
    ('Cape Town CBD',    'Grand Parade, Darling St',        'Cape Town'),
    ('UCT Rugby Fields', 'University of Cape Town Upper Campus', 'Rondebosch, Cape Town');



-- Events (3), owned by the two organizers, each at a venue

INSERT INTO dbo.Event (EventName, EventDate, OrganizerID, VenueID)
VALUES
    ('Soweto Marathon',      '2026-11-01', 1, 1),
    ('Cape Town Cycle Tour', '2026-09-13', 1, 2),
    ('Two Oceans Fun Walk',  '2026-04-04', 2, 3);



-- Categories (at least one per event)

INSERT INTO dbo.Category (CategoryName, EventID)
VALUES
    ('10KM Open',                       1),
    ('21KM Half Marathon',              1),
    ('109KM Individual Time Trial',     2),
    ('5KM Fun Walk',                    3);



-- Enrollments (sample participant sign-ups)

INSERT INTO dbo.Enrollment (ParticipantID, CategoryID)
VALUES
    (1, 2),  -- Sipho -> Soweto 21KM Half Marathon
    (2, 3),  -- Ayesha -> Cape Town Cycle Tour ITT
    (1, 4);  -- Sipho -> Two Oceans Fun Walk



-- Results (sample result for a completed enrollment)

INSERT INTO dbo.Result (EnrollmentID, FinishTime, Position)
VALUES
    (1, '01:45:32', 214);



 SELECT * FROM dbo.Organizer;
 SELECT * FROM dbo.Participant;
 SELECT * FROM dbo.Venue;
 SELECT * FROM dbo.Event;
 SELECT * FROM dbo.Category;
 SELECT * FROM dbo.Enrollment;
 SELECT * FROM dbo.Result;
