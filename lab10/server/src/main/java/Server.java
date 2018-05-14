import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {

    public static void main(String[] args) throws IOException {
        ServerSocket listener = new ServerSocket(8010);
        try {
            while (true) {
                System.out.println("Waiting client...");
                Socket socket = listener.accept();
                System.out.println("Received client...");

                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                try {
                    PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

                    String inputLine = in.readLine();
                    if (null != inputLine) {
                        out.println(inputLine.toUpperCase());
                    }
                    out.flush();
                    out.close();
                } finally {
                    socket.close();
                }
            }
        } finally {
            listener.close();
        }
    }
}