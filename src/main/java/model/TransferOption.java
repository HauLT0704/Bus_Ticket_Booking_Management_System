package model;

public class TransferOption {

    private Trip firstTrip;
    private Trip secondTrip;
    private int transferLocationId;
    private String transferLocationName;

    public TransferOption(Trip firstTrip, Trip secondTrip, int transferLocationId) {
        this.firstTrip = firstTrip;
        this.secondTrip = secondTrip;
        this.transferLocationId = transferLocationId;
    }

    public TransferOption(Trip firstTrip, Trip secondTrip, int transferLocationId, String transferLocationName) {
        this.firstTrip = firstTrip;
        this.secondTrip = secondTrip;
        this.transferLocationId = transferLocationId;
        this.transferLocationName = transferLocationName;
    }

    public Trip getFirstTrip() {
        return firstTrip;
    }

    public Trip getSecondTrip() {
        return secondTrip;
    }

    public int getTransferLocationId() {
        return transferLocationId;
    }

    public String getTransferLocationName() {
        return transferLocationName;
    }

    public void setTransferLocationName(String transferLocationName) {
        this.transferLocationName = transferLocationName;
    }
}