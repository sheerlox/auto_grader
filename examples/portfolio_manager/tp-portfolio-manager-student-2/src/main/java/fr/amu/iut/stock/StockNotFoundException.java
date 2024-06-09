package fr.amu.iut.stock;

class StockNotFoundException extends Exception {
	public StockNotFoundException(String symbol) {
		super("No stock corresponding to the \"" + symbol + "\" symbol was found.");
	}
}
