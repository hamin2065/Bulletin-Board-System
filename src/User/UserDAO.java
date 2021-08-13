package User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bbs.Bbs;

//DB에서 정보를 받아서 객체에 저장
public class UserDAO {
	private Connection conn; //DB 접근 객체 생성
	
	private PreparedStatement pstmt; // SQL문 실행 객체
	private ResultSet rs; // select문 결과를 가지는 객체
	
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			//jdbc -> 자바에서 DB에 접속할 수 있도록 하는 자바 API
			//localhost:3306 -> 내 컴퓨터에 설치된 MySQL, port 3306의 BBS라는 DB에 접속
			
			String dbID = "root";
			String dbPassword = "1234";
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			// MySQL에 접속할 수 있도록 매개체 역할을 하는 라이브러리. JDBC 드라이버 로드
			
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			//DB 접속이 되면 conn 객체에 접속 정보가 저장
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	//로그인 처리
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID =?"; // '?' 자리에 값이 들어와야함
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID); //setString(위치, 값) SQL의 ?자리에 userID를 넣음
			rs = pstmt.executeQuery(); // 쿼리의 결과를 넣는다.(SELECT 문을 실행할 때 사용 -> ResultSet 객체 반환)
			
			if(rs.next()){
				if(rs.getString(1).equals(userPassword)) {
					return 1; //로그인 성공
				}else {
					return 0; //로그인 실패(비밀번호 오류)
				}
			}
			return -1; // 아이디가 없음 -> userID=? 부분 확인
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -2; //DB 오류
	}
	
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?,?,?,?,?)";//DB에 아이디, 비밀번호, 이름, 성별, 이메일 값 INSERT
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();//INSERT된 열의 수 return. 아무 리턴이 없으면 0
		}catch(Exception e) {
			e.printStackTrace();
		}return -1;
	}
	
	public User getUser(String UserID) {
		String SQL = "SELECT * FROM USER WHERE UserID =?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, UserID);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				User user = new User();
				user.setUserID(rs.getString(1));
				user.setUserPassword(rs.getString(2));
				user.setUserName(rs.getString(3));
				user.setUserGender(rs.getString(4));
				user.setUserEmail(rs.getString(5));
				return user;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}return null;
	}
	
	public int delete(String userID, String userPassword) {
		String SQL1 = "SELECT userPassword FROM USER WHERE userID =?";
		try {
			PreparedStatement pstmt1 = conn.prepareStatement(SQL1);
			pstmt1.setString(1, userID);
			rs = pstmt1.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) {
					String SQL2 = "DELETE FROM USER WHERE userID = ?";
					PreparedStatement pstmt2 = conn.prepareStatement(SQL2);
					pstmt2.setString(1, userID);
					return pstmt2.executeUpdate();//삭제 성공 -> 1이 제대로 나오는지 검증
				}else {
					return 0;//비밀번호 틀린경우
				}
			}
			return -1;//아이디가 없는 경우
		}catch(Exception e) {
			e.printStackTrace();
		}return -2;//DB문제
	}
	
	
	public int update(User user) {
		String SQL = "UPDATE USER SET userPassword =?, userName = ?, userGender = ?, userEmail = ?  WHERE UserID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserPassword());
			pstmt.setString(2, user.getUserName());
			pstmt.setString(3, user.getUserGender());
			pstmt.setString(4, user.getUserEmail());
			pstmt.setString(5, user.getUserID());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}return -1;
	}
	
}
