-- DROP TABLES AND VIEWS
DROP VIEW all_users;
DROP VIEW all_loans;
DROP VIEW all_copies;
DROP TABLE Payment;
DROP TABLE Loan;
DROP TABLE MM_Length;
DROP TABLE MM_info;
DROP TABLE Print_author;
DROP TABLE Print_info;
DROP TABLE Copy;
DROP TABLE Resources;
DROP TABLE Resource_shelf;
DROP TABLE Location;
DROP TABLE Users;
DROP TABLE User_Limit;

-- CREATE THE TABLES
CREATE TABLE USER_LIMIT(
USER_TYPE VARCHAR2(10),  
BORROWING_LIMIT NUMBER(2) NOT NULL,
CONSTRAINT PK_USERLIMIT PRIMARY KEY (USER_TYPE)
); 
 
CREATE TABLE USERS(
LIBCARD_ID VARCHAR2(7),
LAST_NAME VARCHAR2(10) NOT NULL,  
FIRST_NAME VARCHAR2(10) NOT NULL,  
COUNTRY_CODE VARCHAR2(3),  
MOBILE_NUMBER VARCHAR2(11),  
USER_TYPE VARCHAR2(10),
USER_STATUS VARCHAR2(12) NOT NULL,
CONSTRAINT PK_USERS PRIMARY KEY (LIBCARD_ID),
CONSTRAINT FK_USERS FOREIGN KEY (USER_TYPE) REFERENCES USER_LIMIT(USER_TYPE),
CONSTRAINT CHECK_STATUS CHECK (USER_STATUS='Active' OR USER_STATUS='Deactivated' OR USER_STATUS='Suspended')
);
 
CREATE TABLE LOCATION(
SHELF_NUMBER VARCHAR2(4),  
FLOOR_NUMBER VARCHAR2(1) NOT NULL,
CONSTRAINT PK_LOCATION PRIMARY KEY (SHELF_NUMBER)
);
 
CREATE TABLE RESOURCE_SHELF(
RESOURCE_CLASS VARCHAR2(30),  
SHELF_NUMBER VARCHAR2(4),
CONSTRAINT PK_RESOURCESHELF PRIMARY KEY(RESOURCE_CLASS, SHELF_NUMBER),
CONSTRAINT FK_RESOURESHELF FOREIGN KEY(SHELF_NUMBER) REFERENCES LOCATION(SHELF_NUMBER)
);
 
CREATE TABLE RESOURCES(
RESOURCE_ID VARCHAR2(8), 
RESOURCE_TYPE VARCHAR2(10), 
RESOURCE_CLASS VARCHAR2(30),
TITLE VARCHAR2(100) NOT NULL,
CONSTRAINT PK_RESOURCES PRIMARY KEY (RESOURCE_ID)
); 

CREATE TABLE COPY (
RESOURCE_ID VARCHAR2(8) NOT NULL, 
COPY_NUMBER VARCHAR2(2) NOT NULL, 
LOAN_PERIOD NUMBER(2) NOT NULL,
CONSTRAINT PK_COPY PRIMARY KEY (RESOURCE_ID, COPY_NUMBER),
CONSTRAINT FK_COPY FOREIGN KEY(RESOURCE_ID) REFERENCES RESOURCES (RESOURCE_ID),
CONSTRAINT COPY_LOANPERIOD CHECK (LOAN_PERIOD BETWEEN -1 AND 14)
);

CREATE TABLE PRINT_INFO(
RESOURCE_ID VARCHAR2(8), 
PUBLISHER VARCHAR2(30), 
ISBN_ISSN VARCHAR2(13) UNIQUE,
CONSTRAINT PK_PRINTINFO PRIMARY KEY (RESOURCE_ID),
CONSTRAINT FK_PRINTINFO FOREIGN KEY (RESOURCE_ID) REFERENCES RESOURCES (RESOURCE_ID) ON DELETE CASCADE
);

CREATE TABLE PRINT_AUTHOR(
RESOURCE_ID VARCHAR2(8),  
AUTHOR VARCHAR2(20),
CONSTRAINT PK_PRINTAUTHOR PRIMARY KEY (RESOURCE_ID, AUTHOR),
CONSTRAINT FK_PRINTAUTHOR FOREIGN KEY (RESOURCE_ID) REFERENCES RESOURCES (RESOURCE_ID) ON DELETE CASCADE
);

CREATE TABLE MM_INFO(
RESOURCE_ID VARCHAR2(8), 
PRODUCER VARCHAR2(30),
CONSTRAINT PK_MMINFO PRIMARY KEY (RESOURCE_ID, PRODUCER),
CONSTRAINT FK_MMINFO FOREIGN KEY (RESOURCE_ID) REFERENCES RESOURCES (RESOURCE_ID) ON DELETE CASCADE
);

CREATE TABLE MM_LENGTH(
RESOURCE_ID VARCHAR2(8), 
LENGTH NUMBER(3) NOT NULL,
CONSTRAINT PK_MMLENGTH PRIMARY KEY (RESOURCE_ID),
CONSTRAINT FK_MMLENGTH FOREIGN KEY (RESOURCE_ID) REFERENCES RESOURCES (RESOURCE_ID) ON DELETE CASCADE
);

CREATE TABLE LOAN(
LOAN_ID NUMBER GENERATED AS IDENTITY, 
LIBCARD_ID VARCHAR2(7), 
RESOURCE_ID VARCHAR2(8), 
COPY_NUMBER VARCHAR2(2), 
DATE_BORROW DATE NOT NULL, 
DATE_RETURN DATE,
CONSTRAINT PK_LOAN PRIMARY KEY (LOAN_ID),
CONSTRAINT FK_LOAN_LIBCARDID FOREIGN KEY (LIBCARD_ID) REFERENCES USERS(LIBCARD_ID),
CONSTRAINT FK_LOAN_COPY FOREIGN KEY (RESOURCE_ID, COPY_NUMBER) REFERENCES COPY(RESOURCE_ID, COPY_NUMBER) ON DELETE SET NULL
);

CREATE TABLE PAYMENT(
LOAN_ID NUMBER,
PAYMENT_AMOUNT NUMBER (4) NOT NULL,
CONSTRAINT PK_PAYMENT PRIMARY KEY (LOAN_ID),
CONSTRAINT FK_PAYMENT FOREIGN KEY (LOAN_ID) REFERENCES LOAN(LOAN_ID)
);

-- INSERT TEST DATA INTO THE TABLES

INSERT INTO User_limit VALUES('Student', 5);
INSERT INTO User_limit VALUES('Staff', 10);

INSERT INTO Users VALUES ('9538839','Kemmis','Loadin','44','12900789282','Student','Active');
INSERT INTO Users VALUES ('8592723','Theodora','Kantor','44','27777068036','Student','Active');
INSERT INTO Users VALUES ('3239001','Bealle','Diperaus','44','50533368146','Student','Deactivated');
INSERT INTO Users VALUES ('4282801','Latisha','Pearson','44','49501947110','Student','Suspended');
INSERT INTO Users VALUES ('5739753','Michaella','Strafen','353','14370969','Student','Active');
INSERT INTO Users VALUES ('2830482','Thibaut','Thorold','44','62051043520','Student','Active');
INSERT INTO Users VALUES ('8083280','Thorsten','Glenn','44','58788472692','Student','Active');
INSERT INTO Users VALUES ('2382819','Jemmy','Wash','44','3262828952','Staff','Active');
INSERT INTO Users VALUES ('7171742','Bary','Medley','44','76023729185','Staff','Active');
INSERT INTO Users VALUES ('6177322','Barbie','Lukasik','358','508381212','Staff','Active');

INSERT INTO Location VALUES ('1004','1');
INSERT INTO Location VALUES ('1011','1');
INSERT INTO Location VALUES ('1024','1');
INSERT INTO Location VALUES ('1027','1');
INSERT INTO Location VALUES ('1032','1');
INSERT INTO Location VALUES ('1049','1');
INSERT INTO Location VALUES ('1052','1');
INSERT INTO Location VALUES ('1054','1');
INSERT INTO Location VALUES ('1063','1');
INSERT INTO Location VALUES ('1070','1');
INSERT INTO Location VALUES ('1080','1');
INSERT INTO Location VALUES ('1082','1');
INSERT INTO Location VALUES ('1091','1');
INSERT INTO Location VALUES ('1094','1');
INSERT INTO Location VALUES ('2017','2');
INSERT INTO Location VALUES ('2019','2');
INSERT INTO Location VALUES ('2026','2');
INSERT INTO Location VALUES ('2040','2');
INSERT INTO Location VALUES ('2043','2');
INSERT INTO Location VALUES ('2045','2');
INSERT INTO Location VALUES ('2056','2');
INSERT INTO Location VALUES ('2057','2');
INSERT INTO Location VALUES ('2092','2');
INSERT INTO Location VALUES ('3051','3');
INSERT INTO Location VALUES ('3073','3');
INSERT INTO Location VALUES ('3074','3');
INSERT INTO Location VALUES ('3077','3');
INSERT INTO Location VALUES ('3084','3');
INSERT INTO Location VALUES ('3095','3');

INSERT INTO Resource_shelf VALUES ('Classic Fiction','1004');
INSERT INTO Resource_shelf VALUES ('Classic Fiction','1011');
INSERT INTO Resource_shelf VALUES ('Classic Fiction','1024');
INSERT INTO Resource_shelf VALUES ('Science Fiction','1027');
INSERT INTO Resource_shelf VALUES ('Science Fiction','1032');
INSERT INTO Resource_shelf VALUES ('Poetry','1049');
INSERT INTO Resource_shelf VALUES ('Short Story','1049');
INSERT INTO Resource_shelf VALUES ('Crime','1049');
INSERT INTO Resource_shelf VALUES ('Textbook','1052');
INSERT INTO Resource_shelf VALUES ('Textbook','1054');
INSERT INTO Resource_shelf VALUES ('Textbook','1063');
INSERT INTO Resource_shelf VALUES ('Journal','1070');
INSERT INTO Resource_shelf VALUES ('Journal','1080');
INSERT INTO Resource_shelf VALUES ('Sports and leisure','1082');
INSERT INTO Resource_shelf VALUES ('Religion','1082');
INSERT INTO Resource_shelf VALUES ('Home and garden','1082');
INSERT INTO Resource_shelf VALUES ('Health','1082');
INSERT INTO Resource_shelf VALUES ('Encyclopedia','1091');
INSERT INTO Resource_shelf VALUES ('Business and economics','1094');
INSERT INTO Resource_shelf VALUES ('Art/architecture','2017');
INSERT INTO Resource_shelf VALUES ('Autobiography','2019');
INSERT INTO Resource_shelf VALUES ('Biography','2026');
INSERT INTO Resource_shelf VALUES ('Business/economics','2040');
INSERT INTO Resource_shelf VALUES ('Crafts/hobbies','2043');
INSERT INTO Resource_shelf VALUES ('Cookbook','2045');
INSERT INTO Resource_shelf VALUES ('Philosophy','2056');
INSERT INTO Resource_shelf VALUES ('Math','2057');
INSERT INTO Resource_shelf VALUES ('Math','2092');
INSERT INTO Resource_shelf VALUES ('Science','3051');
INSERT INTO Resource_shelf VALUES ('Science','3073');
INSERT INTO Resource_shelf VALUES ('Science','3074');
INSERT INTO Resource_shelf VALUES ('Science','3077');
INSERT INTO Resource_shelf VALUES ('Science','3084');
INSERT INTO Resource_shelf VALUES ('Science','3095');

INSERT INTO Resources VALUES ('27369096','Book','Business/economics','The Lean Startup');
INSERT INTO Resources VALUES ('23315921','Book','Dictionary','Macmillan English Dictionary for Advanced Learners');
INSERT INTO Resources VALUES ('88147914','Book','Journal','The Truth about Cancer');
INSERT INTO Resources VALUES ('17649202','Book','Math','The Principia: Mathematical Principles of Natural Philosophy');
INSERT INTO Resources VALUES ('35537314','Book','Science','Introduction to Quantum Mechanics');
INSERT INTO Resources VALUES ('82120851','Book','Science','Fundamentals of Aerodynamics');
INSERT INTO Resources VALUES ('18736414','Book','Biography','Jim Henson: The Biography');
INSERT INTO Resources VALUES ('85815155','Book','Textbook','UNIX and Linux System Administration Handbook');
INSERT INTO Resources VALUES ('43106382','Book','Art/architecture','Between the Lines');
INSERT INTO Resources VALUES ('63290045','Book','Encyclopedia','The Encyclopedia of Gods');
INSERT INTO Resources VALUES ('13951381','Book','Classic Fiction','Huge Dorrit');
INSERT INTO Resources VALUES ('20174519','CD','History','Helen of Troy');
INSERT INTO Resources VALUES ('48527649','CD','Religion','The History of God');
INSERT INTO Resources VALUES ('47452487','CD','Science Fiction','Fated Blades');
INSERT INTO Resources VALUES ('87386855','DVD','Fantasy','Jade Legacy');
INSERT INTO Resources VALUES ('19270142','DVD','Sports and leisure','Best Goals Scored');
INSERT INTO Resources VALUES ('66138583','DVD','Home and garden','Japanese Style Gardens');
INSERT INTO Resources VALUES ('31512743','Video ','Crime','Tinker Tailor Soldier Spy');
INSERT INTO Resources VALUES ('09496244','Video ','Thriller','Crossfire');
INSERT INTO Resources VALUES ('49873226','Video ','Health','Tackling Back Pain');

INSERT INTO Copy VALUES ('27369096','1',14);
INSERT INTO Copy VALUES ('31512743','1',14);
INSERT INTO Copy VALUES ('31512743','2',14);
INSERT INTO Copy VALUES ('87386855','1',14);
INSERT INTO Copy VALUES ('87386855','2',2);
INSERT INTO Copy VALUES ('23315921','1',14);
INSERT INTO Copy VALUES ('09496244','1',14);
INSERT INTO Copy VALUES ('19270142','1',14);
INSERT INTO Copy VALUES ('48527649','1',14);
INSERT INTO Copy VALUES ('88147914','1',14);
INSERT INTO Copy VALUES ('49873226','1',14);
INSERT INTO Copy VALUES ('47452487','1',14);
INSERT INTO Copy VALUES ('17649202','1',14);
INSERT INTO Copy VALUES ('35537314','1',2);
INSERT INTO Copy VALUES ('82120851','1',14);
INSERT INTO Copy VALUES ('18736414','1',14);
INSERT INTO Copy VALUES ('18736414','2',14);
INSERT INTO Copy VALUES ('85815155','1',14);
INSERT INTO Copy VALUES ('85815155','2',14);
INSERT INTO Copy VALUES ('85815155','3',14);
INSERT INTO Copy VALUES ('85815155','4',14);
INSERT INTO Copy VALUES ('85815155','5',14);
INSERT INTO Copy VALUES ('85815155','6',14);
INSERT INTO Copy VALUES ('85815155','7',14);
INSERT INTO Copy VALUES ('85815155','8',2);
INSERT INTO Copy VALUES ('85815155','9',2);
INSERT INTO Copy VALUES ('85815155','10',2);
INSERT INTO Copy VALUES ('85815155','11',-1);
INSERT INTO Copy VALUES ('43106382','1',2);
INSERT INTO Copy VALUES ('63290045','1',-1);
INSERT INTO Copy VALUES ('13951381','1',14);
INSERT INTO Copy VALUES ('13951381','2',14);
INSERT INTO Copy VALUES ('13951381','3',14);
INSERT INTO Copy VALUES ('13951381','4',14);

INSERT INTO Print_info VALUES ('27369096','Rlg Hunting Stands','9781234567897');
INSERT INTO Print_info VALUES ('23315921','Gross Publications','9310831842018');
INSERT INTO Print_info VALUES ('88147914','Dominique Olbrechts','5830813792471');
INSERT INTO Print_info VALUES ('17649202','Edi Multimedia','9541847279186');
INSERT INTO Print_info VALUES ('35537314','Chiworks','3241624917491');
INSERT INTO Print_info VALUES ('82120851','Smith Printing CO','1294719419971');
INSERT INTO Print_info VALUES ('18736414','Sidney Herald','2312083128058');
INSERT INTO Print_info VALUES ('85815155','The Atlanta Tribune','3180538714538');
INSERT INTO Print_info VALUES ('43106382','Mindlab Media Inc','5398164287101');
INSERT INTO Print_info VALUES ('63290045','Alaska Register','3197752917420');
INSERT INTO Print_info VALUES ('13951381','Alaska Register','5748164967101');

INSERT INTO Print_author VALUES ('27369096','J. Wong');
INSERT INTO Print_author VALUES ('27369096','A. Hopkins');
INSERT INTO Print_author VALUES ('23315921','A. Hopkins');
INSERT INTO Print_author VALUES ('88147914','E. Dickinson');
INSERT INTO Print_author VALUES ('17649202','L. Tolstoy');
INSERT INTO Print_author VALUES ('35537314','L. Tolstoy');
INSERT INTO Print_author VALUES ('82120851','L. Tolstoy');
INSERT INTO Print_author VALUES ('18736414','L. Tolstoy');
INSERT INTO Print_author VALUES ('85815155','L. Tolstoy');
INSERT INTO Print_author VALUES ('35537314','R. Howard');
INSERT INTO Print_author VALUES ('82120851','R. Tagore');
INSERT INTO Print_author VALUES ('18736414','M. Hill');
INSERT INTO Print_author VALUES ('85815155','D. Bains');
INSERT INTO Print_author VALUES ('43106382','M. Abe');
INSERT INTO Print_author VALUES ('63290045','J. Ackerman');
INSERT INTO Print_author VALUES ('13951381','T. Adams');
INSERT INTO Print_author VALUES ('85815155','Y. Agnew');
INSERT INTO Print_author VALUES ('85815155','L. Urban');

INSERT INTO MM_info VALUES ('48527649','Sony');
INSERT INTO MM_info VALUES ('47452487','Hachette Livre');
INSERT INTO MM_info VALUES ('87386855','Pixar');
INSERT INTO MM_info VALUES ('19270142','Pan Macmillan');
INSERT INTO MM_info VALUES ('66138583','Bloomsbury');
INSERT INTO MM_info VALUES ('31512743','Walt Disney');
INSERT INTO MM_info VALUES ('49873226','Fox');
INSERT INTO MM_info VALUES ('20174519','Comcast');
INSERT INTO MM_info VALUES ('09496244','Universal Studios');


INSERT INTO MM_length (resource_id,length) VALUES ('20174519','45');
INSERT INTO MM_length (resource_id,length) VALUES ('48527649','47');
INSERT INTO MM_length (resource_id,length) VALUES ('47452487','52');
INSERT INTO MM_length (resource_id,length) VALUES ('87386855','95');
INSERT INTO MM_length (resource_id,length) VALUES ('19270142','126');
INSERT INTO MM_length (resource_id,length) VALUES ('66138583','155');
INSERT INTO MM_length (resource_id,length) VALUES ('31512743','30');
INSERT INTO MM_length (resource_id,length) VALUES ('49873226','28');
INSERT INTO MM_length (resource_id,length) VALUES ('09496244','43');


INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('5739753','35537314','1',TO_DATE('2021-08-30', 'YYYY-MM-DD'),TO_DATE('2021-09-01', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('2382819','17649202','1',TO_DATE('2021-08-31', 'YYYY-MM-DD'),TO_DATE('2021-09-02', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('3239001','82120851','1',TO_DATE('2021-09-01', 'YYYY-MM-DD'),TO_DATE('2021-09-15', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('3239001','18736414','2',TO_DATE('2021-09-01', 'YYYY-MM-DD'),TO_DATE('2021-09-15', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('2830482','43106382','1',TO_DATE('2021-09-02', 'YYYY-MM-DD'),TO_DATE('2021-09-04', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('6177322','85815155','6',TO_DATE('2021-09-04', 'YYYY-MM-DD'),TO_DATE('2021-09-20', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('9538839','85815155','3',TO_DATE('2021-09-05', 'YYYY-MM-DD'),TO_DATE('2021-09-07', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('9538839','13951381','2',TO_DATE('2021-10-06', 'YYYY-MM-DD'),TO_DATE('2021-10-20', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('8592723','13951381','4',TO_DATE('2021-10-08', 'YYYY-MM-DD'),TO_DATE('2021-10-22', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow,date_return) VALUES ('8083280','87386855','1',TO_DATE('2021-11-15', 'YYYY-MM-DD'),TO_DATE('2021-12-08', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow) VALUES ('5739753','85815155','3',TO_DATE('2021-11-22', 'YYYY-MM-DD'));
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow) VALUES ('8592723','17649202','1',TO_DATE('2021-12-04', 'YYYY-MM-DD'));

INSERT INTO Payment VALUES (6,2);

-- View 1 - View for users and librarians to view resources, their copies and their status
CREATE VIEW all_copies AS 
WITH LO AS (SELECT LO.LOAN_ID, LO.RESOURCE_ID, LO.COPY_NUMBER, CO.LOAN_PERIOD, 
    CASE WHEN LO.date_return IS NULL THEN 'YES' END AS Loaned, 
    CASE WHEN LO.date_return IS NULL AND LO.DATE_BORROW + CO.LOAN_PERIOD < SYSDATE THEN 'YES' END AS Overdue, 
    CASE WHEN LO.DATE_RETURN IS NULL THEN LO.DATE_BORROW + CO.LOAN_PERIOD END AS DUE_DATE 
    FROM LOAN LO 
    INNER JOIN COPY CO 
    ON LO.RESOURCE_ID = CO.RESOURCE_ID AND LO.COPY_NUMBER = CO.COPY_NUMBER 
    WHERE LO.date_return IS NULL 
    ORDER BY LOAN_ID) 
SELECT RE_CO_SH.RESOURCE_ID, RE_CO_SH.TITLE, RE_CO_SH.RESOURCE_TYPE, RE_CO_SH.RESOURCE_CLASS, RE_CO_SH.COPY_NUMBER, RE_CO_SH.LOAN_PERIOD, RE_CO_SH.SHELVES, RE_CO_SH.PUBLISHER, RE_CO_SH.ISBN_ISSN, RE_CO_SH.AUTHORS, RE_CO_SH.PRODUCER, RE_CO_SH.LENGTH, LO.LOANED, LO.OVERDUE, LO.DUE_DATE 
FROM ( 
    SELECT C.RESOURCE_ID, C.TITLE, C.RESOURCE_TYPE, C.RESOURCE_CLASS, C.COPY_NUMBER, C.LOAN_PERIOD, SH.SHELVES, C.PUBLISHER, C.ISBN_ISSN, AUT.AUTHORS, C.PRODUCER, C.LENGTH 
    FROM ( 
        SELECT RE.RESOURCE_ID, RE.TITLE, RE.RESOURCE_TYPE, RE.RESOURCE_CLASS, CO.COPY_NUMBER, CO.LOAN_PERIOD, PI.PUBLISHER, PI.ISBN_ISSN, MI.PRODUCER, LEN.LENGTH 
        FROM RESOURCES RE 
        LEFT OUTER JOIN COPY CO 
        ON RE.RESOURCE_ID = CO.RESOURCE_ID 
        FULL OUTER JOIN PRINT_INFO PI  
        ON RE.RESOURCE_ID = PI.RESOURCE_ID 
        FULL OUTER JOIN MM_INFO MI  
        ON RE.RESOURCE_ID = MI.RESOURCE_ID  
        FULL OUTER JOIN MM_LENGTH LEN 
        ON RE.RESOURCE_ID = LEN.RESOURCE_ID 
        ) C  
    LEFT OUTER JOIN ( 
        SELECT RESOURCE_CLASS, LISTAGG(SHELF_NUMBER, '; ') WITHIN GROUP (ORDER BY SHELF_NUMBER) "SHELVES" 
          FROM RESOURCE_SHELF 
          GROUP BY RESOURCE_CLASS 
          ORDER BY RESOURCE_CLASS 
      ) SH 
    ON C.RESOURCE_CLASS = SH.RESOURCE_CLASS 
    FULL OUTER JOIN ( 
        SELECT RESOURCE_ID, LISTAGG(AUTHOR, '; ') WITHIN GROUP (ORDER BY AUTHOR) "AUTHORS" 
          FROM PRINT_AUTHOR 
          GROUP BY RESOURCE_ID 
          ORDER BY RESOURCE_ID 
      ) AUT 
    ON C.RESOURCE_ID = AUT.RESOURCE_ID 
    ) RE_CO_SH 
LEFT OUTER JOIN LO 
ON RE_CO_SH.RESOURCE_ID = LO.RESOURCE_ID AND RE_CO_SH.COPY_NUMBER = LO.COPY_NUMBER 
ORDER BY RE_CO_SH.RESOURCE_TYPE, RE_CO_SH.RESOURCE_ID, RE_CO_SH.COPY_NUMBER;

-- Views
-- View 2 - View all previous and current loans and the corresponding fines
CREATE VIEW all_loans AS
SELECT LO_RE.LOAN_ID, LO_RE.LIBCARD_ID, LO_RE.RESOURCE_ID, LO_RE.RESOURCE_TYPE, LO_RE.TITLE, LO_RE.COPY_NUMBER, CO.LOAN_PERIOD, LO_RE.DATE_BORROW, LO_RE.date_borrow + CO.loan_period AS DATE_DUE, LO_RE.DATE_RETURN,
CASE WHEN LO_RE.date_return IS NOT NULL THEN
    CASE WHEN LO_RE.date_borrow + CO.loan_period < LO_RE.date_return THEN FLOOR(LO_RE.date_return - (LO_RE.date_borrow + CO.loan_period)) END
    ELSE
    CASE WHEN LO_RE.date_borrow + CO.loan_period < SYSDATE THEN FLOOR(SYSDATE - (LO_RE.date_borrow + CO.loan_period)) END
    END AS FINE
FROM (
    SELECT LO.LOAN_ID, LO.RESOURCE_ID, RE.RESOURCE_TYPE, RE.TITLE, LO.LIBCARD_ID, LO.COPY_NUMBER, LO.DATE_BORROW, LO.DATE_RETURN
    FROM LOAN LO
    INNER JOIN RESOURCES RE
    ON LO.RESOURCE_ID = RE.RESOURCE_ID) LO_RE
INNER JOIN COPY CO
ON LO_RE.RESOURCE_ID = CO.RESOURCE_ID AND LO_RE.COPY_NUMBER = CO.COPY_NUMBER
ORDER BY LOAN_ID;

-- View 3 - View all library users, their particulars, and their status
CREATE VIEW all_users AS 
WITH LO AS (
    SELECT LIBCARD_ID, COUNT(LIBCARD_ID) CURRENT_LOAN, SUM(FINE) TOTAL_OS_FINE
    FROM ALL_LOANS
    WHERE DATE_RETURN IS NULL
    GROUP BY LIBCARD_ID, FINE)
SELECT U.LIBCARD_ID, U.LAST_NAME, U.FIRST_NAME, U.COUNTRY_CODE, U.MOBILE_NUMBER, U.USER_TYPE, UL.BORROWING_LIMIT, U.USER_STATUS, LO.CURRENT_LOAN, LO.TOTAL_OS_FINE
FROM LO 
RIGHT OUTER JOIN USERS U 
ON LO.LIBCARD_ID = U.LIBCARD_ID
RIGHT OUTER JOIN USER_LIMIT UL
ON U.USER_TYPE = UL.USER_TYPE
ORDER BY LIBCARD_ID;

 -- Queries
 -- Query 1 - Find the type, the genre, how many copies of it are held by the library and how many are loaned out
SELECT R.RESOURCE_ID, R.RESOURCE_TYPE, R.RESOURCE_CLASS, R.COPIES, LOANCOUNT.LOANED
FROM (
    SELECT RE.RESOURCE_ID, RE.RESOURCE_TYPE, RE.RESOURCE_CLASS, CO.COPIES
    FROM RESOURCES RE
    LEFT OUTER JOIN (SELECT RESOURCE_ID, COUNT(COPY_NUMBER) AS COPIES
    FROM COPY
    GROUP BY RESOURCE_ID) CO
    ON RE.RESOURCE_ID = CO.RESOURCE_ID
) R
FULL OUTER JOIN (
    SELECT RESOURCE_ID, COUNT(RESOURCE_ID) AS LOANED
    FROM LOAN
    WHERE DATE_RETURN IS NULL
    GROUP BY RESOURCE_ID
) LOANCOUNT
ON R.RESOURCE_ID = LOANCOUNT.RESOURCE_ID;

-- Query 2 - See the possible shelf location of all resources, also showing the resource type and genre
-- If one genre returns multiple shelves, show all shelves within one row
SELECT RE.RESOURCE_ID, RE.TITLE, RE.RESOURCE_TYPE, RE.RESOURCE_CLASS, SH.SHELVES
FROM RESOURCES RE
INNER JOIN (
    SELECT RESOURCE_CLASS, LISTAGG(SHELF_NUMBER, '; ') WITHIN GROUP (ORDER BY SHELF_NUMBER) "SHELVES"
      FROM RESOURCE_SHELF
      GROUP BY RESOURCE_CLASS
      ORDER BY RESOURCE_CLASS
  ) SH
ON RE.RESOURCE_CLASS = SH.RESOURCE_CLASS
ORDER BY RESOURCE_TYPE ASC, RESOURCE_CLASS ASC;

-- Query 3 - Find resource with no copies
SELECT * 
FROM RESOURCES RE 
WHERE NOT EXISTS (
    SELECT *
    FROM COPY
    WHERE RE.RESOURCE_ID = COPY.RESOURCE_ID);

-- Query 4 - Add loan record when a copy is being borrowed 
-- For example copy #1 of resource 85815155 is being borrowed by user 4282801
INSERT INTO Loan (libcard_id,resource_id,copy_number,date_borrow) VALUES ('4282801','85815155','1',TO_DATE(SYSDATE));

-- Query 5 - Modify loan record when a copy is being returned 
-- For example copy #1 of resource 17649202 is being returned
UPDATE Loan 
SET date_return = SYSDATE
WHERE date_return IS NULL AND copy_number = '1' AND resource_id = '17649202';

-- Query 6 - Find the top three most borrowed resource
SELECT Re.Resource_ID, Re.Title, Re.Resource_type, Re.Resource_class, Freq.Frequency
FROM (
    SELECT Resource_ID, count(Resource_ID) as Frequency
    FROM Loan
    GROUP BY Resource_ID
    ORDER BY Frequency Desc
) Freq
INNER JOIN RESOURCES Re
ON Freq.Resource_ID = Re.Resource_ID
WHERE ROWNUM <= 3;

-- Query 7 - Find resources borrowed in November that have not been borrowed before
SELECT Nov.Resource_ID, RE.Title, RE.Resource_type, RE.Resource_class
FROM (
    SELECT Resource_ID FROM Loan
    WHERE EXTRACT(MONTH FROM date_borrow) = 11 AND EXTRACT(YEAR FROM date_borrow) = 2021
    MINUS
    SELECT Resource_ID FROM Loan
    WHERE EXTRACT(MONTH FROM date_borrow) < 11) Nov AND EXTRACT(YEAR FROM date_borrow) = 2021
INNER JOIN Resources RE
ON Nov.Resource_ID = RE.Resource_ID;

-- Query 8 - Find the month with the most borrowings and display the number of borrowings in the month
SELECT EXTRACT(MONTH FROM date_borrow) MONTH, COUNT(Loan_ID) "Number of borrowings"
FROM Loan
GROUP BY EXTRACT(MONTH FROM date_borrow)
HAVING COUNT(Loan_ID) = (
    SELECT MAX(COUNT(Loan_ID))
    FROM Loan
    GROUP BY EXTRACT(MONTH FROM date_borrow)
);

-- Query 9 - Find the book(s) jointly authored by L. Tolstoy and M. Hill, its genre, located shelf and floor
SELECT R.RESOURCE_ID, R.RESOURCE_TYPE, R.RESOURCE_CLASS, R.SHELF_NUMBER, LO.FLOOR_NUMBER
FROM(
    SELECT RE.RESOURCE_ID, RE.RESOURCE_TYPE, RE.RESOURCE_CLASS, SH.SHELF_NUMBER
    FROM RESOURCES RE
    INNER JOIN RESOURCE_SHELF SH
    ON RE.RESOURCE_CLASS = SH.RESOURCE_CLASS
    WHERE RESOURCE_ID = 
    (
        SELECT RESOURCE_ID
        FROM PRINT_AUTHOR 
        WHERE AUTHOR = 'L. Tolstoy'
        INTERSECT
        SELECT RESOURCE_ID
        FROM PRINT_AUTHOR
        WHERE AUTHOR = 'M. Hill'
    )
) R
INNER JOIN LOCATION LO
ON R.SHELF_NUMBER = LO.SHELF_NUMBER;

-- Query 10 - Find the resource type with the shortest average length and display the average length
WITH TYPES_LENGTH AS (
    SELECT RESOURCE_TYPE, AVG(LENGTH) AS AVERAGE_LENGTH
        FROM (
            SELECT RE.RESOURCE_ID, RE.RESOURCE_TYPE, LEN.LENGTH
            FROM RESOURCES RE
            INNER JOIN MM_LENGTH LEN
            ON RE.RESOURCE_ID = LEN.RESOURCE_ID
        )
    GROUP BY RESOURCE_TYPE
)
SELECT RESOURCE_TYPE, TO_CHAR(AVERAGE_LENGTH, 'FM9999999.90') AS AVERAGE_LENGTH
FROM TYPES_LENGTH
WHERE AVERAGE_LENGTH = (SELECT MIN(AVERAGE_LENGTH) FROM TYPES_LENGTH);

-- Query 11 - Find the genres with no shelves and shelves with no resources
SELECT RE.RESOURCE_CLASS, SH.SHELF_NUMBER
FROM RESOURCES RE
FULL OUTER JOIN RESOURCE_SHELF SH
ON RE.RESOURCE_CLASS = SH.RESOURCE_CLASS
WHERE RE.RESOURCE_CLASS IS NULL OR SH.SHELF_NUMBER IS NULL;

-- Query 12 - Find the library card IDs of users being suspended for reasons other than currently having an overdue item 
SELECT LIBCARD_ID
FROM USERS
WHERE USER_STATUS = 'Suspended'
MINUS
SELECT LIBCARD_ID
FROM LOAN LO
INNER JOIN COPY CO
ON LO.RESOURCE_ID = CO.RESOURCE_ID AND LO.COPY_NUMBER = CO.COPY_NUMBER
WHERE DATE_RETURN IS NULL AND FLOOR(SYSDATE - (LO.date_borrow + CO.loan_period)) >= 10;

--Triggers
-- Trigger 1 - Stop users from borrowing resources in the following situations:
-- The borrowing limit is reached for the user
-- The resource borrowed can only be used within the library
-- The copy has previously been borrowed but has not been returned properly
-- The user is trying to borrow the same copy for the second time within a day
-- The user is suspended
CREATE OR REPLACE TRIGGER abort_loan
    BEFORE INSERT ON LOAN
    FOR EACH ROW
DECLARE 
    lim User_limit.borrowing_limit%TYPE;
    curr_loan NUMBER(2);
    period NUMBER(2);
    loaned NUMBER(1);
    same_day NUMBER(1);
    status Users.user_status%TYPE;
BEGIN 
    SELECT borrowing_limit 
    INTO lim
    FROM USERS U
    INNER JOIN user_limit ul
    ON U.user_type = ul.user_type
    WHERE libcard_ID = :NEW.libcard_ID;

    SELECT loan_period
    INTO period
    FROM copy
    WHERE resource_id = :NEW.resource_id AND copy_number = :NEW.copy_number;

    BEGIN
        SELECT COUNT(libcard_id)
        INTO curr_loan
        FROM loan
        WHERE date_return IS NULL AND libcard_ID = :NEW.libcard_ID
        GROUP BY libcard_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            curr_loan := 0;
    END;

    BEGIN
        SELECT COUNT(loan_id)
        INTO loaned
        FROM loan
        WHERE date_return IS NULL AND resource_id = :NEW.resource_id AND copy_number = :NEW.copy_number
        GROUP BY loan_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            loaned := 0;
    END;
    
    BEGIN
        SELECT COUNT(loan_id)
        INTO same_day
        FROM loan
        WHERE date_borrow = :NEW.date_borrow AND resource_id = :NEW.resource_id AND copy_number = :NEW.copy_number AND libcard_ID = :NEW.libcard_ID
        GROUP BY loan_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            same_day := 0;
    END;

    SELECT user_status
    INTO status
    FROM USERS
    WHERE libcard_ID = :NEW.libcard_ID;

    IF curr_loan >= lim THEN
        raise_application_error(-20001, 'Borrowing limit is exceeded.');
    ELSIF period = -1 THEN
        raise_application_error(-20001, 'The copy is only allowed to be used within the library');
    ELSIF loaned = 1 THEN
        raise_application_error(-20001, 'The copy has not been returned properly.');
    ELSIF same_day = 1 THEN
        raise_application_error(-20001, 'The copy had been borrowed by the same user today.');
    ELSIF status <> 'Active' THEN   
        raise_application_error(-20001, 'The user is not in active status.');
    END IF;
END;
/

-- Trigger 2 -- Disable loan table updating while 1900 - 0900
CREATE OR REPLACE TRIGGER loan_noot
BEFORE INSERT OR UPDATE
ON loan
DECLARE
l_hour NUMBER;
BEGIN
l_hour := EXTRACT(HOUR FROM SYSTIMESTAMP);
IF l_hour NOT BETWEEN 09 AND 19 THEN
raise_application_error(-20100,'Loan records cannot be altered beyond service hours.');
END IF;
END;
/

-- Trigger 3 - Warn librarian when an overdue item is returned, and audit fine payments by writing to the payment table the loan_id and payment value
-- Compound trigger
CREATE OR REPLACE TRIGGER archive_fine    
    FOR UPDATE OR INSERT ON loan    
    COMPOUND TRIGGER     
    TYPE r_loan_type IS RECORD (    
        loan_id         loan.loan_id%TYPE,      
        resource_id     loan.resource_id%TYPE,
        copy_number     loan.copy_number%TYPE,
        date_borrow     loan.date_borrow%TYPE,
        date_return     loan.date_return%TYPE
    );    

    TYPE t_loan_type IS TABLE OF r_loan_type  
        INDEX BY PLS_INTEGER;    

    t_loan   t_loan_type;    

    AFTER EACH ROW IS    
    BEGIN  
        t_loan (t_loan.COUNT + 1).loan_id := :OLD.loan_id;   
        t_loan (t_loan.COUNT).resource_id := :OLD.resource_id;    
        t_loan (t_loan.COUNT).copy_number := :OLD.copy_number;
        t_loan (t_loan.COUNT).date_borrow := :OLD.date_borrow;
        t_loan (t_loan.COUNT).date_return := :OLD.date_return;
    END AFTER EACH ROW;    

    AFTER STATEMENT IS    
        amnt   payment.payment_amount%TYPE;    
    BEGIN      
        FOR indx IN 1 .. t_loan.COUNT    
        LOOP                                
            SELECT FINE
                INTO amnt
                FROM all_loans
                WHERE loan_id = t_loan(indx).loan_id;
            IF amnt IS NOT NULL    
            THEN    
                INSERT INTO payment VALUES (t_loan(indx).loan_id, amnt);
                dbms_output.put_line( 'Please collect fine: $'  || amnt ||  ' for this copy.' );
            END IF;    
        END LOOP;    
    END AFTER STATEMENT;    
END; 
/


-- Trigger 4: Reactivating users who have paid their fines
CREATE OR REPLACE TRIGGER Reactivate
AFTER INSERT ON Payment
FOR EACH ROW
DECLARE
    usr Users.libcard_ID%TYPE;
    dum Users.libcard_ID%TYPE;
    os BOOLEAN;
BEGIN
    SELECT libcard_ID
    INTO usr
    FROM Loan
    WHERE loan_id = :NEW.loan_id;

    BEGIN
        SELECT libcard_ID
        INTO dum
        FROM all_loans
        WHERE libcard_ID = usr AND date_return IS NULL AND fine >= 10 AND loan_id = :NEW.loan_id;
        os := TRUE;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            os := FALSE;
    END;
    
    IF os = FALSE THEN
    UPDATE Users
        SET user_status = 'Active'
        WHERE
        libcard_ID = usr; 
    END IF;
END;
/

