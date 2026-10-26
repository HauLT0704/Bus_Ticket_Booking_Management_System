package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.TransferOption;
import model.Trip;

/**
 * @author Châu Thành Tâm (TV6)
 */
public class TransferDAO extends DBContext {

    public List<TransferOption> findTransferOptions(
            int fromId, int toId, LocalDate date, int guests) {

        if (guests < 1 || guests > 10) {
            throw new IllegalArgumentException("Invalid number of guests");
        }

        List<TransferOption> options = new ArrayList<>();

        String sql = "SELECT\n"
                + "    t1.Id AS FirstTripId,\n"
                + "    t2.Id AS SecondTripId,\n"
                + "    t1.DepartureTime AS FirstDeparture,\n"
                + "    t2.DepartureTime AS SecondDeparture,\n"
                + "    t1.ArrivalTime AS FirstArrival,\n"
                + "    t2.ArrivalTime AS SecondArrival,\n"
                + "    t1.AvailableSeats AS FirstAvailableSeats,\n"
                + "    t2.AvailableSeats AS SecondAvailableSeats,\n"
                + "    t1.Price AS FirstPrice,\n"
                + "    t2.Price AS SecondPrice,\n"
                + "    (t1.Price + t2.Price) AS TotalPrice,\n"
                + "    r1.ToLocationId AS TransferLocationId\n"
                + "FROM Trips t1\n"
                + "INNER JOIN Routes r1 ON t1.RouteId = r1.Id\n"
                + "INNER JOIN Routes r2 ON r1.ToLocationId = r2.FromLocationId\n"
                + "INNER JOIN Trips t2 ON t2.RouteId = r2.Id\n"
                + "WHERE r1.FromLocationId = ?\n"
                + "  AND r2.ToLocationId = ?\n"
                + "  AND t1.AvailableSeats >= ?\n"
                + "  AND t2.AvailableSeats >= ?\n"
                + "  AND DATEADD(MINUTE, 15, t1.ArrivalTime) <= t2.DepartureTime\n"
                + "  AND DATEADD(MINUTE, 75, t1.ArrivalTime) >= t2.DepartureTime\n"
                + "  AND t1.Status = N'Sắp khởi hành'\n"
                + "  AND t2.Status = N'Sắp khởi hành'\n"
                + "  AND CAST(t1.DepartureTime AS DATE) = ?\n"
                + "ORDER BY t1.DepartureTime, t2.DepartureTime";

        try (PreparedStatement statement
                = this.getConnection().prepareStatement(sql)) {

            statement.setInt(1, fromId);
            statement.setInt(2, toId);
            statement.setInt(3, guests);
            statement.setInt(4, guests);
            statement.setDate(5, java.sql.Date.valueOf(date));

            try (ResultSet rs = statement.executeQuery()) {

                while (rs.next()) {
                    Trip first = new Trip();
                    Trip second = new Trip();

                    first.setId(rs.getInt("FirstTripId"));
                    second.setId(rs.getInt("SecondTripId"));

                    first.setDepartureTime(rs.getTimestamp("FirstDeparture"));
                    second.setDepartureTime(rs.getTimestamp("SecondDeparture"));

                    first.setArrivalTime(rs.getTimestamp("FirstArrival"));
                    second.setArrivalTime(rs.getTimestamp("SecondArrival"));

                    first.setAvailableSeats(rs.getInt("FirstAvailableSeats"));
                    second.setAvailableSeats(rs.getInt("SecondAvailableSeats"));

                    first.setPrice(rs.getDouble("FirstPrice"));
                    second.setPrice(rs.getDouble("SecondPrice"));

                    TransferOption option = new TransferOption(
                            first,
                            second,
                            rs.getInt("TransferLocationId")
                    );

                    options.add(option);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(TransferDAO.class.getName())
                    .log(Level.SEVERE, "Error finding transfer options", ex);

            throw new IllegalStateException(
                    "Cannot find transfer options", ex
            );
        }

        return options;
    }
}
