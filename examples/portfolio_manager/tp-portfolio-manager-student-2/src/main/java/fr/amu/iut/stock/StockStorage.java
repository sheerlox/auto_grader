package fr.amu.iut.stock;

import java.util.List;

/**
 * An interface for storing and managing the quantity of stocks.
 */
public interface StockStorage {

	/**
	 * Retrieves a list of symbols of all stocks stored in the storage.
	 *
	 * @return A list of symbols of all stocks stored in the storage.
	 */
	List<String> listSymbols();

	/**
	 * Retrieves the quantity of the specified stock.
	 *
	 * @param symbol The symbol of the stock.
	 * @return The quantity of the specified stock. Returns 0 if the stock is not found.
	 */
	int get(String symbol);

	/**
	 * Stores or updates the quantity of the specified stock.
	 *
	 * @param symbol   The symbol of the stock.
	 * @param quantity The quantity of the stock to be stored or updated.
	 */
	void put(String symbol, int quantity);
}
