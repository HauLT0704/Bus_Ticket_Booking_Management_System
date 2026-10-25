package model;

public class TransferOption {

    private Trip firstTrip;
    private Trip secondTrip;
    private int transferLocationId;

    public TransferOption(Trip firstTrip, Trip secondTrip, int transferLocationId) {
        this.firstTrip = firstTrip;
        this.secondTrip = secondTrip;
        this.transferLocationId = transferLocationId;
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
}