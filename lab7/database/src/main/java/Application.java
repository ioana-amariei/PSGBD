import oracle.jdbc.OracleResultSet;

import java.math.BigDecimal;
import java.sql.*;

/*
 * This Java source file was generated by the Gradle 'init' task.
 */
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

        String insert = "INSERT INTO CARS VALUES (car(?, ?, ?))";
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