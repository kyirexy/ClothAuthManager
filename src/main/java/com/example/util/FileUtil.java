package com.example.util;

import jakarta.servlet.http.Part;
import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUtil {
    private static ServletContext servletContext;

    // 设置ServletContext的方法
    public static void setServletContext(ServletContext context) {
        servletContext = context;
    }

    public static String saveImage(Part filePart) throws IOException {
        String fileName = filePart.getSubmittedFileName();
        String fileExtension = getFileExtension(fileName);
        String newFileName = UUID.randomUUID().toString() + fileExtension;
        
        // 获取项目的实际部署路径
        String uploadPath = servletContext.getRealPath("/static/images");
        System.out.println("Upload path: " + uploadPath); // 调试信息
        
        // 确保上传目录存在
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // 保存文件
        String filePath = uploadPath + File.separator + newFileName;
        System.out.println("Saving file to: " + filePath); // 调试信息
        filePart.write(filePath);
        
        // 返回相对路径（不带前导斜杠）
        return "static/images/" + newFileName;
    }

    // 修改getFileExtension方法，接收String参数
    private static String getFileExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return ".jpg"; // 默认扩展名
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

    // 验证文件类型
    public static boolean isImageFile(Part filePart) {
        String contentType = filePart.getContentType();
        if (contentType == null) {
            return false;
        }
        return contentType.startsWith("image/");
    }

    // 验证文件大小
    public static boolean isFileSizeValid(Part filePart, long maxSize) {
        return filePart.getSize() <= maxSize;
    }

    // 删除图片
    public static boolean deleteImage(String imagePath) {
        if (imagePath == null || imagePath.trim().isEmpty()) {
            return false;
        }

        String realPath = servletContext.getRealPath(imagePath);
        File file = new File(realPath);
        return file.exists() && file.delete();
    }
} 