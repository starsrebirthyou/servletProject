package everytable.notice.vo;

public class NoticeVO {

	private long no;  // 글 고유 번호
	private String title;  // 제목
	private String content;  // 내용
	private String fileName;
	private String writeDate;  // 공지 최초 등록일
	private String updateDate;  // 공지 수정일
	private long cateNo;  // 공지 유형 번호
	private String cateName;  // 공지 유형 이름
	private long hit;		// 조회수
	
	public long getNo() {
		return no;
	}
	public void setNo(long no) {
		this.no = no;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}	
	public long getCateNo() {
		return cateNo;
	}
	public void setCateNo(long cateNo) {
		this.cateNo = cateNo;
	}	
	public String getCateName() {
		return cateName;
	}
	public void setCateName(String cateName) {
		this.cateName = cateName;
	}
	public long getHit() {
		return hit;
	}
	public void setHit(long hit) {
		this.hit = hit;
	}
	
	@Override
	public String toString() {
		return "NoticeVO [no=" + no + ", title=" + title + ", content=" + content + ", fileName=" + fileName
				+ ", writeDate=" + writeDate + ", updateDate=" + updateDate + ", cateNo=" + cateNo + ", cateName="
				+ cateName + ", hit=" + hit + "]";
	}
	
}