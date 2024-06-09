package fr.amu.iut.stock;

import java.util.List;

public class StockPortfolio {
    private StockAPI stockAPI;
    private StockStorage stockStorage;

    public StockPortfolio(StockAPI stockAPI, StockStorage stockStorage) {
        this.stockAPI = stockAPI;
        this.stockStorage = stockStorage;
    }

    public void addStockQuantity(String symbol, int quantityToAdd) throws IllegalArgumentException{
            if (quantityToAdd <= 0){
                throw new IllegalArgumentException();
            }

        if(stockStorage.listSymbols().contains(symbol)) {
            int quantity = stockStorage.get(symbol);
            stockStorage.put(symbol, quantityToAdd + quantity);
        }
        stockStorage.put(symbol, quantityToAdd);

    }

    public void removeStockQuantity(String symbol, int quantityToRemove) throws NotEnoughStockQuantityException, IllegalArgumentException {
        if (quantityToRemove <= 0){
            throw new IllegalArgumentException();
        }
        if(stockStorage.listSymbols().contains(symbol)) {
            int quantity = stockStorage.get(symbol);
            if(quantity < quantityToRemove) {
                throw new NotEnoughStockQuantityException();
            }
            stockStorage.put(symbol, quantity - quantityToRemove);
        }
        else {
            throw new NotEnoughStockQuantityException();
        }
    }

    public double getStockPortfolioValue(String symbol) throws StockNotFoundException {
        if(stockStorage.listSymbols().contains(symbol)) {
            int quantity = stockStorage.get(symbol);
            double stockPrice = stockAPI.getStockPrice(symbol);
            return quantity * stockPrice;
        }
        return 0.0;
    }

    public double getTotalPortfolioValue() throws StockNotFoundException {
        return 0.0;
    }
}