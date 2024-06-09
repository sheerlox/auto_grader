package fr.amu.iut.stock;

import java.util.List;

public class StockPortfolio {
	private StockAPI stockAPI;
	private StockStorage stockStorage;

	public StockPortfolio(StockAPI stockAPI, StockStorage stockStorage) {
		this.stockAPI = stockAPI;
		this.stockStorage = stockStorage;
	}

	public void addStockQuantity(String symbol, int quantityToAdd) {
		if (quantityToAdd >= 0) this.stockStorage.put(symbol, quantityToAdd);
		else throw new IllegalArgumentException();
	}

	public void removeStockQuantity(String symbol, int quantityToRemove) throws NotEnoughStockQuantityException {
		if (quantityToRemove >= 0 && 
			quantityToRemove <= this.stockStorage.get(symbol)) 
			this.stockStorage.put(symbol, quantityToRemove * -1);
		else if (quantityToRemove > this.stockStorage.get(symbol)) throw new NotEnoughStockQuantityException();
		else throw new IllegalArgumentException();

	}

	public double getStockPortfolioValue(String symbol) throws StockNotFoundException {
		return this.stockStorage.get(symbol) * this.stockAPI.getStockPrice(symbol);
	}

	public double getTotalPortfolioValue() throws StockNotFoundException {
		double count = 0;
		for (int i = 0; i < this.stockStorage.listSymbols().size(); ++i) {
			String symbol = this.stockStorage.listSymbols().get(i);
			count += this.getStockPortfolioValue(symbol);
		}
		return count;
	}
}
