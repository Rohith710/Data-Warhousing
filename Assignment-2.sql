/*Assignment-2, 1st Question*/
CREATE DATABASE Worker;
SHOW databases;

USE Worker;

/* 2nd Question*/
CREATE TABLE Department (
    DepartmentID INT NOT NULL PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

INSERT INTO Department (DepartmentID, DepartmentName) VALUES (1, 'Research & Development');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (2, 'Production');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (3, 'IT Support');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (4, 'Operations');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (5, 'Customer Service');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (6, 'Purchasing');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (7, 'Sales & Marketing');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (8, 'Human Resource Management');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (9, 'Accounting & Financing');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (10, 'Legal Department');

SELECT * FROM Department ORDER BY DepartmentID;



/* 3rd Question*/

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    HireDate DATE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

INSERT INTO Employee (EmployeeID, FirstName, LastName, HireDate, DepartmentID) VALUES 
(1, 'Andy', 'Wong', '2001-01-15', 1),
(2, 'John', 'Wilson', '2017-03-19', 2),
(3, 'Vivek', 'Pandey', '2003-11-15', 3),
(4, 'Nola', 'Davis', '2016-03-23', 4);

INSERT INTO Employee (EmployeeID, FirstName, LastName, HireDate, DepartmentID) VALUES
(5, 'Kathy', 'Cooper', '2011-11-18', 5),
(6, 'Tom', 'Harper', '2010-04-11', 6);

SELECT * FROM Employee ORDER BY EmployeeID;


/* 4th Question*/

CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY,
    EquipmentName VARCHAR(255) NOT NULL,
    EquipmentCostAmount DECIMAL(10, 2) NOT NULL
);

INSERT INTO Equipment (EquipmentID, EquipmentName, EquipmentCostAmount) VALUES 
(1, 'NoteBook Computers', 1000.00),
(2, 'Headsets', 150.00),
(3, 'Computer Moniters', 5000.00);

INSERT INTO Equipment (EquipmentID, EquipmentName, EquipmentCostAmount) VALUES 
(4, 'Multi-Function printer', 100.00),
(5, 'Projector', 850.00),
(6, 'Servers', 1600.00),
(7, 'Internet Modem', 300.00),
(8, 'Cell Phone', 600.00);

SELECT * FROM Equipment ORDER BY EquipmentID;

/* 5th Question*/
CREATE TABLE EmployeeEquipment (
    EmployeeID INT,
    EquipmentID INT,
    PRIMARY KEY (EmployeeID, EquipmentID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

INSERT INTO EmployeeEquipment (EmployeeID, EquipmentID) VALUES 
(1,1),
(2,1),
(2,3),
(3,1),
(3,2),
(3,3),
(4,1),
(4,2),
(5,1),
(5,2),
(5,3),
(6,1),
(6,3);

SELECT * FROM EmployeeEquipment ORDER BY EmployeeID, EquipmentID;


/* 6th Question*/

CREATE TABLE Training (
    TrainingID INT PRIMARY KEY,
    TrainingName VARCHAR(255) NOT NULL
);

INSERT INTO Training (TrainingID, TrainingName) VALUES 
(1, 'Covid-19 Awareness and Protection Training'),
(2, 'Code of Conduct Training'),
(3, 'Saftey Training'),
(4, 'Intro to python'),
(5, 'Machine Learning'),
(6, 'Microsoft Certifications'),
(7, 'Security and Privacy'),
(8, 'Product Knowledge'),
(9, 'Sales Skills'),
(10,'Employee Relations'),
(11,'Travel and Expense Management');

SELECT * FROM Training ORDER BY TrainingID;


/* 7th Question*/
CREATE TABLE EmployeeTraining (
    EmployeeID INT,
    TrainingID INT,
    PRIMARY KEY (EmployeeID, TrainingID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (TrainingID) REFERENCES Training(TrainingID)
);
INSERT INTO EmployeeTraining (EmployeeID, TrainingID) VALUES 
(1, 2),
(1,3),
(2, 2),
(2,4),
(2,5),
(3,2),
(3,6),
(3,7),
(4,2),
(4,8),
(4,9),
(5,2),
(5,10),
(6,2),
(6,11);

SELECT * FROM EmployeeTraining ORDER BY EmployeeID, TrainingID;

/* 8th Question*/

CREATE TABLE Trainer (
    TrainerID INT PRIMARY KEY,
    TrainerFirstName VARCHAR(255) NOT NULL,
    TrainerLastName VARCHAR(255)
);

INSERT INTO Trainer (TrainerID, TrainerFirstName, TrainerLastName) VALUES 
(1, 'James', 'Smith'),
(2, 'Jhonny ', 'Khor'),
(3, 'Michael', 'Smith'),
(4, 'Maria ', 'Gracia'),
(5, 'John', NULL),
(6, 'Paul ', 'Dietel'),
(7, 'Mike', 'Taylor'),
(8, ' Avinash', 'Nalvani'),
(9, 'Robert','Smith'),
(10, 'Maria ','Rodriguez'),
(11, 'Mike','Donlon'),
(12, 'Kathy','Corby'),
(13, 'Mary','Gracia'),
(14, 'Vanesa',NULL),
(15, 'Jordan',NULL),
(16, 'Maria', 'Hernandez');


SELECT * FROM Trainer ORDER BY TrainerID;

/* 9th Question*/

SELECT * FROM Trainer WHERE TrainerLastName IS NULL ORDER BY TrainerID;

/* 10th Question*/

SHOW tables;

/* 11th Question*/

SELECT EmployeeID, FirstName, LastName, HireDate
FROM Employee
WHERE HireDate > (SELECT HireDate FROM Employee WHERE FirstName = 'Vivek' AND LastName = 'Pandey')
ORDER BY EmployeeID;

/* 12th Question*/

SELECT E.FirstName, E.LastName, T.TrainingName
FROM Employee E
INNER JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
INNER JOIN Training T ON ET.TrainingID = T.TrainingID
WHERE E.FirstName = 'Tom' AND E.LastName = 'Harper'
ORDER BY T.TrainingName;

/* 13th Question*/

SELECT T.TrainingName, TR.TrainerFirstName, TR.TrainerLastName
FROM Training T
INNER JOIN EmployeeTraining ET ON T.TrainingID = ET.TrainingID
INNER JOIN Trainer TR ON ET.EmployeeID = TR.TrainerID
ORDER BY T.TrainingName, TR.TrainerFirstName, TR.TrainerLastName;

/* 14th Question*/

SELECT E.EmployeeID, E.FirstName, E.LastName, E.HireDate
FROM Employee E
WHERE E.DepartmentID IN (
    SELECT DepartmentID FROM Department WHERE DepartmentName IN ('Accounting and Finance', 'IT Support', 'Production')
)
ORDER BY E.EmployeeID;

/* 15th Question*/
SELECT E.EmployeeID, E.FirstName, E.LastName, EQ.EquipmentName, EQ.EquipmentCostAmount
FROM Employee E
INNER JOIN EmployeeEquipment EE ON E.EmployeeID = EE.EmployeeID
INNER JOIN Equipment EQ ON EE.EquipmentID = EQ.EquipmentID
ORDER BY E.EmployeeID;

/* 16th Question*/

SELECT T.TrainingID, T.TrainingName, TR.TrainerID, TR.TrainerFirstName, TR.TrainerLastName
FROM Training T
INNER JOIN Trainer TR ON T.TrainingID = TR.TrainerID
WHERE TR.TrainerLastName IS NULL
ORDER BY T.TrainingID, TR.TrainerID;

/* 17th Question*/

SELECT DISTINCT EQ.EquipmentName
FROM Equipment EQ
INNER JOIN EmployeeEquipment EE ON EQ.EquipmentID = EE.EquipmentID
ORDER BY EQ.EquipmentName;

/*18th Question*/

SELECT E.EmployeeID, E.FirstName, E.LastName, E.HireDate, D.DepartmentName
FROM Employee E
INNER JOIN Department D ON E.DepartmentID = D.DepartmentID
WHERE E.HireDate > '2021-01-01'
ORDER BY E.EmployeeID;


/*19th Question */

SELECT T.TrainingName, TR.TrainerFirstName, TR.TrainerLastName
FROM Training T
INNER JOIN EmployeeTraining ET ON T.TrainingID = ET.TrainingID
INNER JOIN Trainer TR ON ET.EmployeeID = TR.TrainerID
ORDER BY T.TrainingName, TR.TrainerFirstName, TR.TrainerLastName;


/*20th Question */

SELECT E.EmployeeID, E.FirstName, E.LastName, EQ.EquipmentName, EQ.EquipmentCostAmount
FROM Employee E
INNER JOIN EmployeeEquipment EE ON E.EmployeeID = EE.EmployeeID
INNER JOIN Equipment EQ ON EE.EquipmentID = EQ.EquipmentID
ORDER BY E.EmployeeID;
























