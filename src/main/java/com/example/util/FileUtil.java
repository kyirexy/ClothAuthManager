package com.example.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUtil {
    // 修改为新的图片存储路径
    private static final String IMAGE_UPLOAD_PATH = "D:\\develop\\Java\\project\\javaweb\\ClothAuthManager\\src\\main\\webapp\\static\\images";
    
    public static String saveImage(Part filePart) throws IOException {
        // 确保目录存在
        File uploadDir = new File(IMAGE_UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 获取文件扩展名
        String fileName = filePart.getSubmittedFileName();
        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
        
        // 生成新的文件名
        String newFileName = UUID.randomUUID().toString() + fileExtension;
        
        // 完整的文件保存路径
        String filePath = IMAGE_UPLOAD_PATH + File.separator + newFileName;
        
        // 保存文件
        filePart.write(filePath);
        
        // 返回相对路径，用于数据库存储和前端显示
        return "/static/images/" + newFileName;
    }

    public static boolean deleteImage(String imagePath) {
        if (imagePath == null || imagePath.trim().isEmpty()) {
            return false;
        }

        // 如果路径以static/images开头，需要添加完整路径
        if (imagePath.startsWith("/static/images/")) {
            imagePath = "D:\\develop\\Java\\project\\javaweb\\ClothAuthManager\\src\\main\\webapp" + imagePath;
        }

        File file = new File(imagePath);
        return file.exists() && file.delete();
    }

    // 验证文件类型
    public static boolean isImageFile(Part filePart) {
        String contentType = filePart.getContentType();
        if (contentType == null) {
            return false;
        }
        // 验证是否为图片类型
        return contentType.startsWith("image/");
    }

    // 验证文件大小（可选）
    public static boolean isFileSizeValid(Part filePart, long maxSize) {
        return filePart.getSize() <= maxSize;
    }

    // 获取文件扩展名（可选）
    public static String getFileExtension(Part filePart) {
        String fileName = filePart.getSubmittedFileName();
        return fileName.substring(fileName.lastIndexOf("."));
    }
} 