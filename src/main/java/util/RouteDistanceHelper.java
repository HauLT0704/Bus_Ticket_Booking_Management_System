package util;

import java.text.Normalizer;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Tiện ích hỗ trợ quản lý cự ly, thời gian chuẩn và ràng buộc logic tuyến đường xe khách.
 * Áp dụng cho các tuyến Miền Tây (Đồng bằng Sông Cửu Long) & TP. Hồ Chí Minh.
 */
public class RouteDistanceHelper {

    public static class RouteInfo {
        private final double distance; // km
        private final int duration;    // phút

        public RouteInfo(double distance, int duration) {
            this.distance = distance;
            this.duration = duration;
        }

        public double getDistance() {
            return distance;
        }

        public int getDuration() {
            return duration;
        }
    }

    // Map lưu trữ cự ly chuẩn giữa 2 địa phương
    private static final Map<String, RouteInfo> STANDARD_MAP = new HashMap<>();

    static {
        // ID 1: TP. Hồ Chí Minh
        add(1, 2, "TP. Hồ Chí Minh", "Cần Thơ", 165.0, 180);
        add(1, 3, "TP. Hồ Chí Minh", "Kiên Giang", 250.0, 300);
        add(1, 4, "TP. Hồ Chí Minh", "An Giang", 240.0, 330);
        add(1, 5, "TP. Hồ Chí Minh", "Cà Mau", 350.0, 450);
        add(1, 6, "TP. Hồ Chí Minh", "Bạc Liêu", 280.0, 360);
        add(1, 7, "TP. Hồ Chí Minh", "Sóc Trăng", 230.0, 300);
        add(1, 8, "TP. Hồ Chí Minh", "Đồng Tháp", 150.0, 180);
        add(1, 9, "TP. Hồ Chí Minh", "Bến Tre", 85.0, 120);
        add(1, 10, "TP. Hồ Chí Minh", "Vĩnh Long", 135.0, 150);
        add(1, 11, "TP. Hồ Chí Minh", "Tiền Giang", 70.0, 90);
        add(1, 12, "TP. Hồ Chí Minh", "Trà Vinh", 130.0, 180);
        add(1, 13, "TP. Hồ Chí Minh", "Hậu Giang", 200.0, 240);
        add(1, 14, "TP. Hồ Chí Minh", "Long An", 45.0, 60);

        // ID 2: Cần Thơ
        add(2, 3, "Cần Thơ", "Kiên Giang", 110.0, 150);
        add(2, 4, "Cần Thơ", "An Giang", 65.0, 90);
        add(2, 5, "Cần Thơ", "Cà Mau", 180.0, 240);
        add(2, 6, "Cần Thơ", "Bạc Liêu", 110.0, 150);
        add(2, 7, "Cần Thơ", "Sóc Trăng", 62.0, 90);
        add(2, 8, "Cần Thơ", "Đồng Tháp", 80.0, 100);
        add(2, 9, "Cần Thơ", "Bến Tre", 115.0, 150);
        add(2, 10, "Cần Thơ", "Vĩnh Long", 35.0, 45);
        add(2, 11, "Cần Thơ", "Tiền Giang", 105.0, 130);
        add(2, 12, "Cần Thơ", "Trà Vinh", 75.0, 100);
        add(2, 13, "Cần Thơ", "Hậu Giang", 45.0, 60);
        add(2, 14, "Cần Thơ", "Long An", 135.0, 160);

        // ID 3: Kiên Giang
        add(3, 4, "Kiên Giang", "An Giang", 75.0, 100);
        add(3, 5, "Kiên Giang", "Cà Mau", 130.0, 180);
        add(3, 6, "Kiên Giang", "Bạc Liêu", 130.0, 170);
        add(3, 7, "Kiên Giang", "Sóc Trăng", 140.0, 190);
        add(3, 8, "Kiên Giang", "Đồng Tháp", 145.0, 200);
        add(3, 9, "Kiên Giang", "Bến Tre", 190.0, 260);
        add(3, 10, "Kiên Giang", "Vĩnh Long", 130.0, 180);
        add(3, 11, "Kiên Giang", "Tiền Giang", 190.0, 250);
        add(3, 12, "Kiên Giang", "Trà Vinh", 170.0, 230);
        add(3, 13, "Kiên Giang", "Hậu Giang", 75.0, 100);
        add(3, 14, "Kiên Giang", "Long An", 215.0, 270);

        // ID 4: An Giang
        add(4, 5, "An Giang", "Cà Mau", 230.0, 310);
        add(4, 6, "An Giang", "Bạc Liêu", 170.0, 230);
        add(4, 7, "An Giang", "Sóc Trăng", 120.0, 160);
        add(4, 8, "An Giang", "Đồng Tháp", 50.0, 70);
        add(4, 9, "An Giang", "Bến Tre", 165.0, 220);
        add(4, 10, "An Giang", "Vĩnh Long", 90.0, 120);
        add(4, 11, "An Giang", "Tiền Giang", 160.0, 210);
        add(4, 12, "An Giang", "Trà Vinh", 135.0, 180);
        add(4, 13, "An Giang", "Hậu Giang", 95.0, 130);
        add(4, 14, "An Giang", "Long An", 195.0, 250);

        // ID 5: Cà Mau
        add(5, 6, "Cà Mau", "Bạc Liêu", 70.0, 90);
        add(5, 7, "Cà Mau", "Sóc Trăng", 120.0, 150);
        add(5, 8, "Cà Mau", "Đồng Tháp", 240.0, 320);
        add(5, 9, "Cà Mau", "Bến Tre", 260.0, 350);
        add(5, 10, "Cà Mau", "Vĩnh Long", 210.0, 280);
        add(5, 11, "Cà Mau", "Tiền Giang", 275.0, 360);
        add(5, 12, "Cà Mau", "Trà Vinh", 210.0, 280);
        add(5, 13, "Cà Mau", "Hậu Giang", 140.0, 190);
        add(5, 14, "Cà Mau", "Long An", 310.0, 400);

        // ID 6: Bạc Liêu
        add(6, 7, "Bạc Liêu", "Sóc Trăng", 50.0, 65);
        add(6, 8, "Bạc Liêu", "Đồng Tháp", 180.0, 240);
        add(6, 9, "Bạc Liêu", "Bến Tre", 200.0, 270);
        add(6, 10, "Bạc Liêu", "Vĩnh Long", 145.0, 190);
        add(6, 11, "Bạc Liêu", "Tiền Giang", 210.0, 280);
        add(6, 12, "Bạc Liêu", "Trà Vinh", 150.0, 200);
        add(6, 13, "Bạc Liêu", "Hậu Giang", 85.0, 110);
        add(6, 14, "Bạc Liêu", "Long An", 245.0, 320);

        // ID 7: Sóc Trăng
        add(7, 8, "Sóc Trăng", "Đồng Tháp", 135.0, 180);
        add(7, 9, "Sóc Trăng", "Bến Tre", 150.0, 200);
        add(7, 10, "Sóc Trăng", "Vĩnh Long", 95.0, 125);
        add(7, 11, "Sóc Trăng", "Tiền Giang", 165.0, 210);
        add(7, 12, "Sóc Trăng", "Trà Vinh", 60.0, 80);
        add(7, 13, "Sóc Trăng", "Hậu Giang", 65.0, 85);
        add(7, 14, "Sóc Trăng", "Long An", 195.0, 250);

        // ID 8: Đồng Tháp
        add(8, 9, "Đồng Tháp", "Bến Tre", 105.0, 140);
        add(8, 10, "Đồng Tháp", "Vĩnh Long", 45.0, 60);
        add(8, 11, "Đồng Tháp", "Tiền Giang", 85.0, 110);
        add(8, 12, "Đồng Tháp", "Trà Vinh", 95.0, 130);
        add(8, 13, "Đồng Tháp", "Hậu Giang", 105.0, 140);
        add(8, 14, "Đồng Tháp", "Long An", 115.0, 150);

        // ID 9: Bến Tre
        add(9, 10, "Bến Tre", "Vĩnh Long", 55.0, 75);
        add(9, 11, "Bến Tre", "Tiền Giang", 20.0, 30);
        add(9, 12, "Bến Tre", "Trà Vinh", 55.0, 75);
        add(9, 13, "Bến Tre", "Hậu Giang", 140.0, 180);
        add(9, 14, "Bến Tre", "Long An", 60.0, 80);

        // ID 10: Vĩnh Long
        add(10, 11, "Vĩnh Long", "Tiền Giang", 65.0, 80);
        add(10, 12, "Vĩnh Long", "Trà Vinh", 55.0, 75);
        add(10, 13, "Vĩnh Long", "Hậu Giang", 75.0, 95);
        add(10, 14, "Vĩnh Long", "Long An", 100.0, 130);

        // ID 11: Tiền Giang
        add(11, 12, "Tiền Giang", "Trà Vinh", 70.0, 95);
        add(11, 13, "Tiền Giang", "Hậu Giang", 140.0, 180);
        add(11, 14, "Tiền Giang", "Long An", 35.0, 45);

        // ID 12: Trà Vinh
        add(12, 13, "Trà Vinh", "Hậu Giang", 110.0, 145);
        add(12, 14, "Trà Vinh", "Long An", 115.0, 155);

        // ID 13: Hậu Giang
        add(13, 14, "Hậu Giang", "Long An", 170.0, 220);
    }

    private static void add(int id1, int id2, String name1, String name2, double dist, int duration) {
        RouteInfo info = new RouteInfo(dist, duration);
        STANDARD_MAP.put(makeIdKey(id1, id2), info);
        STANDARD_MAP.put(makeNameKey(name1, name2), info);
    }

    private static String makeIdKey(int id1, int id2) {
        int min = Math.min(id1, id2);
        int max = Math.max(id1, id2);
        return min + "---" + max;
    }

    private static String makeNameKey(String name1, String name2) {
        String n1 = normalizeName(name1);
        String n2 = normalizeName(name2);
        if (n1.compareTo(n2) < 0) {
            return n1 + "---" + n2;
        } else {
            return n2 + "---" + n1;
        }
    }

    public static String normalizeName(String name) {
        if (name == null) return "";
        String normalized = Normalizer.normalize(name, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        String noAccents = pattern.matcher(normalized).replaceAll("")
                .replaceAll("đ", "d")
                .replaceAll("Đ", "d")
                .toLowerCase()
                .replaceAll("^(tp\\.?|thanh pho|tinh)\\s*", "")
                .replaceAll("[^a-z0-9]", "");
        return noAccents;
    }

    /**
     * Tra cứu thông tin tuyến đường tiêu chuẩn giữa 2 địa điểm
     */
    public static RouteInfo getStandardRoute(int fromId, int toId, String fromName, String toName) {
        if (fromId > 0 && toId > 0) {
            RouteInfo info = STANDARD_MAP.get(makeIdKey(fromId, toId));
            if (info != null) {
                return info;
            }
        }
        if (fromName != null && toName != null) {
            RouteInfo info = STANDARD_MAP.get(makeNameKey(fromName, toName));
            if (info != null) {
                return info;
            }
        }
        return null;
    }

    public static RouteInfo getStandardRoute(int fromId, int toId) {
        return getStandardRoute(fromId, toId, null, null);
    }

    /**
     * Kiểm tra ràng buộc logic cho tuyến đường.
     * @return null nếu hợp lệ; chuỗi thông báo lỗi cụ thể nếu không hợp lệ.
     */
    public static String validateRoute(double distance, int duration, int fromId, int toId, String fromName, String toName) {
        if (fromId <= 0 || toId <= 0) {
            return "Vui lòng chọn đầy đủ Điểm đi và Điểm đến!";
        }
        if (fromId == toId) {
            return "Điểm đi và Điểm đến không được trùng nhau!";
        }

        // 1. Ràng buộc khoảng cách tối thiểu / tối đa (xe khách liên tỉnh tối thiểu 20 km)
        if (distance < 20.0 || distance > 1000.0) {
            return "Khoảng cách tuyến đường liên tỉnh không hợp lệ! Khoảng cách phải từ 20.0 km đến 1,000.0 km (bạn đã nhập: " + distance + " km).";
        }

        // 2. Ràng buộc thời gian di chuyển dự kiến (tối thiểu 30 phút, tối đa 24 giờ)
        if (duration < 30 || duration > 1440) {
            return "Thời gian di chuyển dự kiến không hợp lệ! Thời gian tối thiểu phải từ 30 phút trở lên (tối đa 24 giờ) (bạn đã nhập: " + duration + " phút).";
        }

        // 3. Ràng buộc tốc độ trung bình di chuyển của xe khách (25 km/h <= v <= 100 km/h)
        double speed = distance / (duration / 60.0);
        if (speed < 25.0) {
            return String.format("Tốc độ trung bình quá chậm (%.1f km/h)! Xe khách liên tỉnh phải di chuyển với tốc độ trung bình từ 25.0 km/h đến 100.0 km/h.", speed);
        }
        if (speed > 100.0) {
            return String.format("Tốc độ trung bình vượt quá giới hạn an toàn (%.1f km/h)! Xe khách liên tỉnh chỉ được lưu thông tối đa 100.0 km/h.", speed);
        }

        // 4. So sánh với cự ly chuẩn nếu có trong hệ thống
        RouteInfo std = getStandardRoute(fromId, toId, fromName, toName);
        if (std != null) {
            double diffRatio = Math.abs(distance - std.getDistance()) / std.getDistance();
            if (diffRatio > 0.35) {
                String fromDisplay = (fromName != null && !fromName.isEmpty()) ? fromName : "Điểm đi";
                String toDisplay = (toName != null && !toName.isEmpty()) ? toName : "Điểm đến";
                return String.format("Khoảng cách nhập vào (%.1f km) sai lệch quá lớn so với thực tế! Tuyến %s - %s có cự ly chuẩn là khoảng %.1f km (thời gian ~ %d phút). Vui lòng nhập thông tin sát với thực tế!",
                        distance, fromDisplay, toDisplay, std.getDistance(), std.getDuration());
            }
        }

        return null;
    }
}

