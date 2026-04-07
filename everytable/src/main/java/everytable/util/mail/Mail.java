package everytable.util.mail;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Mail {

	public static void sendMail(String to, String subject, String content) throws Exception {
        // 1. Gmail SMTP 서버 설정
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // TLS 보안 연결 사용
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // 2. 인증 정보
        final String username = "jooyeonoh3526777@gmail.com"; // 본인 지메일 주소
        final String password = "rrsj pqgi tzro cyks"; // 구글에서 발급받은 16자리 앱 비밀번호

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        // 3. 메일 구성 및 전송
        Message message = new MimeMessage(session);
        // 보내는 사람 설정 (이름은 자유롭게 변경 가능)
        message.setFrom(new InternetAddress(username, "에브리테이블")); 
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(subject);
        message.setContent(content, "text/html; charset=utf-8"); // HTML 형식 지원

        Transport.send(message);
    }
	
}
