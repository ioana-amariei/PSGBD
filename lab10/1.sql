--1. (3pt) HTTP Request
--Creati o procedura stocata care se va conecta la un server Web si va face un simplu HTTP request. 
--Functia va avea ca parametri, numele host-ului si port-ul respectiv. 
--Rezultatul primit va fi afisat in functia creata. 
--In cazul in care nu va puteti conecta la host, se va afisa doar 'FAIL'. 
--Testati intr-un bloc anonim pentru cateva host-uri. 

CREATE OR REPLACE PROCEDURE connectToWebServer(hostName IN VARCHAR2, httpPort IN NUMERIC) AS 
    CONN            UTL_TCP.CONNECTION;
    RETVAL          BINARY_INTEGER;
BEGIN
     --Deschidem conexiunea...
    CONN := UTL_TCP.OPEN_CONNECTION(
        REMOTE_HOST   => hostName,
        REMOTE_PORT   => httpPort,
        TX_TIMEOUT    => 10
    );
    
    RETVAL := UTL_TCP.WRITE_LINE(CONN,'GET / HTTP/1.0');
    RETVAL := UTL_TCP.WRITE_LINE(CONN);
    UTL_TCP.FLUSH(CONN);
    
    DBMS_OUTPUT.PUT_LINE('Response from Server : ');
    BEGIN
        WHILE UTL_TCP.AVAILABLE(CONN, 10) > 0 LOOP
            DBMS_OUTPUT.PUT_LINE(UTL_TCP.GET_LINE(CONN,TRUE));
        END LOOP;
    EXCEPTION
        WHEN UTL_TCP.END_OF_INPUT THEN
            NULL; -- end of input
    END;
    
    UTL_TCP.CLOSE_CONNECTION(CONN);
END;
/

SET SERVEROUTPUT ON
/

DECLARE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Response from emag : ' || connectToWebServer('www.emag.ro', 80));
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('Response from teora : ' || connectToWebServer('www.teora.ro', 80));
    DBMS_OUTPUT.PUT_LINE('');
END;
/




