-- Documentation sources
--https://oracle-base.com/articles/misc/email-from-oracle-plsql
--http://groglogs.blogspot.ro/2013/06/plsql-oracle-send-mail-through-smtp.html

CREATE OR REPLACE PROCEDURE sendMail(hostName IN VARCHAR2, smtpPort IN NUMERIC DEFAULT 25)  
AS  
  mailFrom  VARCHAR2(100) := 'ioana.birsan@info.uaic.ro';  
  mailTo VARCHAR2(100) := 'ioana.c.birsan@gmail.com';
  messageSubject VARCHAR2(50) := 'Send email test'; 
  messageBody VARCHAR2(10000) := 'Test success';
  encoded_username VARCHAR2(100);
  encoded_password VARCHAR2(100);
  smtp_conn UTL_SMTP.connection;  
BEGIN  
    DBMS_OUTPUT.PUT_LINE('Start');
    --open connection : without authentication
--    smtp_conn := UTL_SMTP.open_connection(hostName, smtpPort);  
--    UTL_SMTP.helo(smtp_conn, hostName); 

    --open connection : with authentication
    encoded_username := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw('ioana.birsan')));  
    encoded_password := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw('Amariei_asD321')));  
    smtp_conn := UTL_SMTP.open_connection(hostName, smtpPort);  
    UTL_SMTP.ehlo(smtp_conn, hostName);
    UTL_SMTP.command(smtp_conn, 'AUTH', 'LOGIN');  
    UTL_SMTP.command(smtp_conn, encoded_username);  
    UTL_SMTP.command(smtp_conn, encoded_password); 
    DBMS_OUTPUT.PUT_LINE('Connection established');
    
    --prepare headers  
    UTL_SMTP.mail(smtp_conn, mailFrom);  
    UTL_SMTP.rcpt(smtp_conn, mailTo);
    DBMS_OUTPUT.PUT_LINE('Headers prepared');
 
    --start multi line message  
    UTL_SMTP.open_data(smtp_conn);  
    DBMS_OUTPUT.PUT_LINE('Multi-line message started');
 
    --prepare mail header  
    UTL_SMTP.write_data(smtp_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || UTL_TCP.crlf);  
    UTL_SMTP.write_data(smtp_conn, 'To: ' || mailTo || UTL_TCP.crlf);  
    UTL_SMTP.write_data(smtp_conn, 'From: ' || mailFrom || UTL_TCP.crlf);  
    UTL_SMTP.write_data(smtp_conn, 'Subject: ' || messageSubject || UTL_TCP.crlf || UTL_TCP.crlf);  
    DBMS_OUTPUT.PUT_LINE('Mail headers prepared');
      
    --include the message body  
    UTL_SMTP.write_data(smtp_conn, messageBody || UTL_TCP.crlf || UTL_TCP.crlf);  
    DBMS_OUTPUT.PUT_LINE('Message body included');
      
    --send the email  
    UTL_SMTP.close_data(smtp_conn);  
    UTL_SMTP.quit(smtp_conn);  
    DBMS_OUTPUT.PUT_LINE('MAIL SENT');
END;  
/
 
set serveroutput on;

DECLARE   
    v_mail_host VARCHAR2(100) := 'fenrir.info.uaic.ro';
    --v_mail_host VARCHAR2(100) := '85.122.23.145';
    fenrir_port NUMERIC := 25;
BEGIN  
    sendMail(v_mail_host, fenrir_port);   
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Sending failed: '||SQLERRM);  
END;  

--alter system set smtp_out_server = 'fenrir.info.uaic.ro';
 