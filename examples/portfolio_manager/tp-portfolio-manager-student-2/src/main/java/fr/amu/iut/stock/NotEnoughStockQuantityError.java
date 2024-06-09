package fr.amu.iut.stock;

class NotEnoughStockQuantityException extends Exception {
	public NotEnoughStockQuantityException() {
		super("Cannot remove more stock quantity than currently owned.");
	}
}
