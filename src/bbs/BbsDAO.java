package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			
			String dbID = "root";
			String dbPassword = "1234";
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	//게시판에 글을 작성할 때 현재의 시간을 가져오는 함수
	public String getDate() {
		String SQL = "SELECT NOW()"; //현재 시간을 가져오는 쿼리문
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getString(1);//현재 시간 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";//데이터 베이스 오류
	}
	
	//게시글 번호 입력 함수
	public int getNext() {
		String SQL = "SELECT bbsID FROM bbs ORDER BY bbsID DESC";
		//게시글 번호는 1번부터 2번,3번,4번... 올라가서 마지막의 번호를 가져와서 +1 해준다.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getInt(1)+1;//마지막 게시글 번호에서 +1 해준다.
			}
			return 1; //첫 번째 게시물인 경우
		}catch(Exception e) {
			e.printStackTrace();
		}return -1;//데이터 베이스 오류
	}
	
	//실제 글을 작성
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO bbs VALUE(?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()); //bbsID
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}return -1;
	}
	
	//글의 목록을 가져오는 함수
	public ArrayList<Bbs> getList(int pageNumber){
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		//bbsID가 특정조건보다 작을 때, Available = 1(삭제가 되지 않고), 10개까지 제한해서 나타냄
		
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1)*10);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}return list;
	}
	
	//페이징 처리
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber - 1)*10);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}return false;
	}
	
	//하나의 글을 읽어오는 함수
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID =?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}return null;
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle =?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}return -1;
	}
	
	public int delete(int bbsID) {
		//실제 데이터를 삭제하는 것이 아니라 게시글 유효 숫자를 '0'으로 수정
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID =?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}return -1;
	}
}
