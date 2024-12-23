package com.example.util;


import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUtil {
    private static final String UPLOAD_PATH = "D:\\develop\\Java\\project\\javaweb\\ClothAuthManager\\src\\main\\resources\\static\\images\\";
    private static final String[] ALLOWED_TYPES = {".jpg", ".jpeg", ".png", ".gif"};

    public static String saveImage(Part filePart) throws IOException {
        // 获取文件名
        String fileName = filePart.getSubmittedFileName();
        String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();

        // 检查文件类型
        boolean isAllowedType = false;
        for (String type : ALLOWED_TYPES) {
            if (type.equals(fileExtension)) {
                isAllowedType = true;
                break;
            }
        }
        if (!isAllowedType) {
            throw new IOException("不支持的文件类型");
        }

        // 生成新文件名
        String newFileName = UUID.randomUUID().toString() + fileExtension;
        String filePath = UPLOAD_PATH + newFileName;

        // 确保目录存在
        File uploadDir = new File(UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 保存文件
        filePart.write(filePath);

        // 返回相对路径
        return "static/images/" + newFileName;
    }

    public static void deleteImage(String imagePath) {
        if (imagePath != null && !imagePath.equals(UPLOAD_PATH + "img.png")) {
            File file = new File(UPLOAD_PATH + imagePath.substring(imagePath.lastIndexOf("/") + 1));
            if (file.exists()) {
                file.delete();
            }
        }
    }
} 