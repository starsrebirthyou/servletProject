package everytable.util.image;

import java.awt.Color;                 // 색상을 표현하기 위한 클래스
import java.awt.Graphics2D;            // 2D 그래픽 작업을 위한 클래스
import java.awt.RenderingHints;        // 이미지 품질 향상을 위한 옵션 클래스
import java.awt.image.BufferedImage;   // 이미지를 메모리에 담기 위한 클래스
import java.io.File;                   // 파일 처리를 위한 클래스
import javax.imageio.ImageIO;          // 이미지 읽기/쓰기 클래스

/**
 * 이미지에 관련된 메서드를 지원한 객체 : ImageUtil
 * <p>
 * resizing(파일의 절대 위치, 파일명, 앞에 붙이는 문자열, 너비, 높이, 나머지 배경색)
 * <p>
 * @과정명 : 한양여자대학교 부트 캠프
 * @작성자 : 이영환
 * @작성일 : 2026-03-06
 * @버전 : 1.0
 * @환경 : JDK 17
 * 
 */

public class ImageUtil {

    public static void resizing(String savePath, String fileName, String pre, int w, int h, Color bg)
    throws Exception{

            // 원본 이미지 파일 객체 생성
            File srcFile = new File(savePath, fileName);

            // 원본 이미지를 BufferedImage 객체로 읽어온다
            BufferedImage srcImg = ImageIO.read(srcFile);

            // 원본 이미지의 너비를 가져온다
            int srcWidth = srcImg.getWidth();

            // 원본 이미지의 높이를 가져온다
            int srcHeight = srcImg.getHeight();

            // 원본 이미지의 가로 비율을 계산한다
            double ratioX = (double) w / srcWidth;

            // 원본 이미지의 세로 비율을 계산한다
            double ratioY = (double) h / srcHeight;

            // 가로/세로 중 더 작은 비율을 선택하여 이미지 비율이 유지되도록 한다
            double ratio = Math.min(ratioX, ratioY);

            // 비율을 적용하여 새로운 이미지 너비를 계산한다
            int newWidth = (int) (srcWidth * ratio);

            // 비율을 적용하여 새로운 이미지 높이를 계산한다
            int newHeight = (int) (srcHeight * ratio);

            // 최종 결과 이미지를 담을 BufferedImage 객체를 생성한다
            BufferedImage destImg = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);

            // Graphics2D 객체를 생성하여 이미지 그리기 작업을 준비한다
            Graphics2D g = destImg.createGraphics();

            // 배경색을 설정한다
            g.setColor(bg);

            // 지정된 크기(w,h) 전체 영역을 배경색으로 채운다
            g.fillRect(0, 0, w, h);

            // 이미지 품질 향상을 위해 렌더링 옵션을 설정한다
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);

            // 가로 가운데 정렬을 위해 시작 X 좌표를 계산한다
            int x = (w - newWidth) / 2;

            // 세로 가운데 정렬을 위해 시작 Y 좌표를 계산한다
            int y = (h - newHeight) / 2;

            // 원본 이미지를 계산된 위치와 크기로 리사이즈하여 그린다
            g.drawImage(srcImg, x, y, newWidth, newHeight, null);

            // 그래픽 리소스를 해제한다
            g.dispose();

            // 저장할 새 파일명을 생성한다 (pre + 원본파일명)
            String newFileName = pre + fileName;

            // 저장할 파일 객체를 생성한다
            File destFile = new File(savePath, newFileName);

            // 파일 확장자를 추출한다
            String format = fileName.substring(fileName.lastIndexOf('.') + 1);

            // 리사이즈된 이미지를 파일로 저장한다
            ImageIO.write(destImg, format, destFile);

    }
}