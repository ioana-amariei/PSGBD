CREATE TYPE person FORCE AS OBJECT
  (first_name VARCHAR2(10),
   last_name VARCHAR2(10),
   age NUMBER,
   
   MEMBER PROCEDURE printInfo
);

/

CREATE OR REPLACE TYPE BODY person AS
    MEMBER PROCEDURE printInfo AS
      BEGIN
        DBMS_OUTPUT.PUT_LINE('First name: ' || SELF.first_name);
        DBMS_OUTPUT.PUT_LINE('Last name: ' || SELF.last_name);
        DBMS_OUTPUT.PUT_LINE('Age: ' || SELF.age);
      END printInfo;
END;

/

DROP TABLE persons;
/
CREATE TABLE persons(person_object person);
/

set serveroutput on;
DECLARE
  CURSOR persons_list IS SELECT * FROM persons;
  first_person person;
BEGIN
  OPEN persons_list;
  LOOP
    FETCH persons_list INTO first_person;
    EXIT WHEN persons_list%NOTFOUND;
    first_person.printInfo;
  END LOOP;
  CLOSE persons_list;
END;

/

/*************************************************************************************************************/


CREATE OR REPLACE TYPE employee FORCE AS OBJECT
  (first_name VARCHAR2(10),
   surname VARCHAR2(10),
   rank  NUMBER,
   id NUMBER,
   birthdate DATE,
   salary NUMBER,

  MEMBER FUNCTION setRandomID RETURN NUMBER,
  CONSTRUCTOR FUNCTION employee(first_name VARCHAR2, surname VARCHAR2) RETURN SELF AS RESULT,
  MEMBER PROCEDURE setID,
  MEMBER FUNCTION getID RETURN NUMBER,
  MEMBER PROCEDURE setFirstName(p_first_name IN VARCHAR2),
  MEMBER FUNCTION getFirstName RETURN VARCHAR2,
  MEMBER PROCEDURE setSurname(p_surname IN VARCHAR2),
  MEMBER FUNCTION getSurname RETURN VARCHAR2,
  MEMBER PROCEDURE setRank(p_rank IN NUMBER),
  MEMBER FUNCTION getRank RETURN NUMBER,
  MEMBER PROCEDURE setBirthdate(p_birthdate IN DATE),
  MEMBER FUNCTION getBirthdate RETURN DATE,
  MEMBER PROCEDURE setSalary(p_salary IN NUMBER),
  MEMBER PROCEDURE setSalary(p_salary IN NUMBER, p_percentage IN NUMBER),
  MEMBER FUNCTION getSalary RETURN NUMBER,
  ORDER MEMBER FUNCTION compare(p_employee employee) RETURN NUMBER,
  NOT FINAL MEMBER PROCEDURE displayEmployeeInfo
  
) NOT FINAL;

/

CREATE OR REPLACE TYPE BODY employee AS

  MEMBER FUNCTION setRandomID RETURN NUMBER AS
    BEGIN
      RETURN DBMS_RANDOM.VALUE(1,200);
    END;

  CONSTRUCTOR FUNCTION employee(first_name VARCHAR2, surname VARCHAR2)
    RETURN SELF AS RESULT
  AS
  BEGIN
    SELF.first_name := first_name;
    SELF.surname := surname;
    SELF.birthdate := sysdate;
    SELF.rank := round(DBMS_RANDOM.VALUE(1,10));
    SELF.id := setRandomID();
    SELF.salary := 1500 * SELF.rank;
    RETURN;
  END;

  MEMBER PROCEDURE setID AS
    BEGIN
      SELF.id := setRandomID();
    END;

  MEMBER FUNCTION getID RETURN NUMBER AS
    BEGIN
      RETURN round(SELF.id, -1);
    END;

  MEMBER PROCEDURE setFirstName(p_first_name IN VARCHAR2) AS
    BEGIN
      SELF.first_name := p_first_name;
    END;

  MEMBER FUNCTION getFirstName RETURN VARCHAR2 AS
    BEGIN
      RETURN SELF.first_name;
    END;

  MEMBER PROCEDURE setSurname(p_surname IN VARCHAR2) AS
    BEGIN
      SELF.surname := p_surname;
    END;

  MEMBER FUNCTION getSurname RETURN VARCHAR2 AS
    BEGIN
      RETURN SELF.surname;
    END;

  MEMBER PROCEDURE setRank(p_rank IN NUMBER) AS
    BEGIN
      SELF.rank := p_rank;
    END;

  MEMBER FUNCTION getRank RETURN NUMBER AS
    BEGIN
      RETURN SELF.rank;
    END;

  MEMBER PROCEDURE setBirthdate(p_birthdate IN DATE) AS
    BEGIN
      SELF.birthdate := p_birthdate;
    END;

  MEMBER FUNCTION getBirthdate RETURN DATE AS
    BEGIN
      RETURN SELF.birthdate;
    END;

  ORDER MEMBER FUNCTION compare(p_employee employee) RETURN NUMBER AS
    BEGIN
      IF SELF.rank < p_employee.rank THEN RETURN -1;
      ELSIF SELF.rank = p_employee.rank THEN RETURN 0;
      ELSE RETURN 1;
      END IF;
    END;

  MEMBER PROCEDURE setSalary(p_salary IN NUMBER) AS
    BEGIN
      SELF.salary := p_salary;
    END;
    
  MEMBER PROCEDURE setSalary(p_salary IN NUMBER, p_percentage IN NUMBER) AS
    BEGIN
      SELF.salary := SELF.salary + SELF.salary * (p_percentage/100);
    END;

  MEMBER FUNCTION getSalary RETURN NUMBER AS 
    BEGIN
      RETURN SELF.salary;
    END;

   MEMBER PROCEDURE displayEmployeeInfo AS
   BEGIN
     DBMS_OUTPUT.PUT_LINE('First name: ' || SELF.first_name);
     DBMS_OUTPUT.PUT_LINE('Surname: ' || SELF.surname);
     DBMS_OUTPUT.PUT_LINE('Rank: ' || SELF.rank);
     DBMS_OUTPUT.PUT_LINE('ID: ' || SELF.id);
     DBMS_OUTPUT.PUT_LINE('Birthdate: ' || SELF.birthdate);
     DBMS_OUTPUT.PUT_LINE('Salary: ' || SELF.salary);
     DBMS_OUTPUT.PUT_LINE('');
   END displayEmployeeInfo;
END;

/

DROP TYPE employee_of_the_month;

/

CREATE OR REPLACE TYPE employee_of_the_month UNDER employee
(    
   bonus NUMBER,
   OVERRIDING MEMBER PROCEDURE displayEmployeeInfo
);
/

CREATE OR REPLACE TYPE BODY employee_of_the_month AS

    OVERRIDING MEMBER PROCEDURE displayEmployeeInfo AS
    BEGIN
      (SELF AS employee).displayEmployeeInfo;
      DBMS_OUTPUT.PUT_LINE('Salary bonus: ' || SELF.bonus);
      DBMS_OUTPUT.PUT_LINE('');
    END displayEmployeeInfo;
  
END;
/

set serveroutput on;

DROP TABLE EMPLOYEES;
/
CREATE TABLE EMPLOYEES(first_name VARCHAR2(10), surname VARCHAR2(10), rank NUMBER, id NUMBER, birthdate DATE, salary NUMBER);
/

DECLARE
  first_employee employee;
  v_id NUMBER;

  e1 employee;
  e2 employee;
  e3 employee;
  e4 employee;

  best_employee employee_of_the_month;
  v_bonus NUMBER;
BEGIN
  first_employee := new employee('Amariei', 'Daniel', 4, 1, TO_DATE('12-APR-1988'), 1234);
  first_employee.displayEmployeeInfo;
  
  first_employee.setSalary(1200);
  DBMS_OUTPUT.PUT_LINE('Initial salary: ' || first_employee.getSalary);
  first_employee.setSalary(1200, 10);
  DBMS_OUTPUT.PUT_LINE('After appling percentage raise to salary: ' || first_employee.getSalary);
  DBMS_OUTPUT.PUT_LINE('');

  e1 := new employee('Popescu', 'Ion');
  e2 := new employee('Birsan', 'Ioana');
  e3 := new employee('Amariei', 'Daniel');
  e4 := new employee('Cercel', 'Anda');

  INSERT INTO EMPLOYEES VALUES(e1.getFirstName, e1.getSurname, e1.getRank, e1.getID, e1.getBirthdate, e1.getSalary);
  INSERT INTO EMPLOYEES VALUES(e2.getFirstName, e2.getSurname, e2.getRank, e2.getID, e2.getBirthdate, e2.getSalary);
  INSERT INTO EMPLOYEES VALUES(e3.getFirstName, e3.getSurname, e3.getRank, e3.getID, e3.getBirthdate, e3.getSalary);
  INSERT INTO EMPLOYEES VALUES(e4.getFirstName, e4.getSurname, e4.getRank, e4.getID, e4.getBirthdate, e4.getSalary);
  
  best_employee := new employee_of_the_month('Amariei', 'Daniel', 10, 12, TO_DATE('12-APR-1988'), 1000, 50);
  
  DBMS_OUTPUT.PUT_LINE('Employee of the month info');
  best_employee.displayEmployeeInfo;
END;

/*
// Created by AMI on 2018-04-12.

public class Person {
    public String first_name;
    public String last_name;
    public int age;

    public Person(String first_name, String last_name, int age) {
        this.first_name = first_name;
        this.last_name = last_name;
        this.age = age;
    }

    @Override
    public String toString() {
        return "Person{" +
                "first_name='" + first_name + '\'' +
                ", last_name='" + last_name + '\'' +
                ", age=" + age +
                '}';
    }
}

import oracle.jdbc.OracleResultSet;
import java.math.BigDecimal;
import java.sql.*;

// This Java source file was generated by the Gradle 'init' task.

public class Application {

    public static void main(String[] args) throws Exception {
        serialize();
        deserialize();
    }

    private static void deserialize() throws Exception {
        Connection connection = getOracleConnection();
        String select = "SELECT * FROM PERSONS";

        PreparedStatement statement = connection.prepareStatement(select);
        ResultSet resultSet = statement.executeQuery();

        resultSet.next();
        oracle.sql.STRUCT oracleSTRUCT=(oracle.sql.STRUCT)resultSet.getObject(1);
        Object[] objects = oracleSTRUCT.getAttributes();

        String first_name = (String) objects[0];
        String last_name = (String) objects[1];
        int age = ((BigDecimal) objects[2]).intValue();
        Person person = new Person(first_name, last_name, age);
        System.out.println(person);
    }

    private static void serialize() throws Exception {
        Connection connection = getOracleConnection();

        String insert = "INSERT INTO PERSONS VALUES (person(?, ?, ?))";
        CallableStatement statement = connection.prepareCall(insert);

        Person person = createPerson();
        statement.setString(1, person.first_name);
        statement.setString(2, person.last_name);
        statement.setInt(3, person.age);

        statement.execute();
    }

    public static Connection getOracleConnection() throws Exception {
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String username = "student";
        String password = "STUDENT";

        Class.forName(driver); // load Oracle driver
        Connection conn = DriverManager.getConnection(url, username, password);
        return conn;
    }

    public static Person createPerson(){
        return new Person("Amariei", "Ioana", 29);
    }
}
*/
