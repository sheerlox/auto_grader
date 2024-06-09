package fr.amu.iut.stock;

interface StockAPI {
	/**
	 * Retrieves the current price of a stock with the given symbol.
	 *
	 * @param symbol the symbol of the stock.
	 * @return the current price of the stock.
	 * @throws StockNotFoundException if the stock does not exist.
	 */
	double getStockPrice(String symbol) throws StockNotFoundException;
}
