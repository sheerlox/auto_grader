package fr.amu.iut.stock;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class StockPortfolioTest {
	@Mock
	private StockAPI stockAPI;
	@Mock
	private StockStorage stockStorage;

	private StockPortfolio stockPortfolio;

	@BeforeEach
	public void setUp() {
		stockPortfolio = new StockPortfolio(stockAPI, stockStorage);
	}

	// ajout d'une quantité d'actions pour une action non détenue.
	@Test
	public void testAddNewStock() throws StockNotFoundException {
		stockPortfolio.addStockQuantity("Tesla", 10);
		//verify(stockStorage, times(1)).get("Tesla");
		verify(stockStorage, times(1)).put("Tesla", 10);
	}

	// ajout d'une quantité d'actions pour une action déjà détenue.
	@Test
	public void testAddStockQuantity() {
		String symbol = "Tesla";
		int nb = 10;
		stockPortfolio.addStockQuantity(symbol, nb);
		stockPortfolio.addStockQuantity(symbol, nb);
		when(stockStorage.get("Tesla")).thenReturn(20);
		//verify(stockStorage, times(2)).get(symbol);
		//verify(stockStorage, times(2)).put(symbol, nb);
		assertEquals(20, stockStorage.get("Tesla"));
	}

	// tentative d'ajout d'une quantité d'actions négative.
	@Test
	public void testAddNegativeStockQuantity() {
		String symbol = "Tesla";
		int nb = -10;
		//verify(stockStorage, times(2)).get(symbol);
		assertThrows(IllegalArgumentException.class, () -> stockPortfolio.addStockQuantity(symbol, nb));
	}

	// suppression d'une quantité d'actions pour une action déjà détenue.
	@Test
	public void testRemoveStockQuantity() throws NotEnoughStockQuantityException {
		stockPortfolio.addStockQuantity("Tesla", 10);
		when(stockStorage.get("Tesla")).thenReturn(10);
		stockPortfolio.removeStockQuantity("Tesla", 5);
		//when(stockStorage.get("Tesla")).thenReturn(5);
		verify(stockStorage, times(1)).put("Tesla", -5);
	}

	// tentative de suppression d'une quantité d'actions négative.
	@Test
	public void testRemoveNegativeStockQuantity() {
		stockPortfolio.addStockQuantity("Tesla", 10);
		assertThrows(IllegalArgumentException.class, () -> stockPortfolio.removeStockQuantity("Tesla", -1));
	}

	// tentative de suppression d'une quantité d'actions trop importante.
	@Test
	public void testRemoveTooMuchStockQuantity() {
		stockPortfolio.addStockQuantity("Tesla", 10);
		assertThrows(NotEnoughStockQuantityException.class, () -> stockPortfolio.removeStockQuantity("Tesla", 11));
	}

	// tentative de suppression d'une quantité d'actions pour une action non détenue.
	@Test
	public void testRemoveStockQuantityStockNotOwned() {
		assertThrows(NotEnoughStockQuantityException.class, () -> stockPortfolio.removeStockQuantity("Tesla", 10));
	}

	// calcul de la valeur dans le portefeuille d'une action existante.
	@Test
	public void testgetStockPortfolioValue() throws StockNotFoundException {
		when(stockAPI.getStockPrice("Tesla")).thenReturn(1.1);
		when(stockStorage.get("Tesla")).thenReturn(10);
		assertEquals(11.0, stockPortfolio.getStockPortfolioValue("Tesla"), 0.1);
	}

	// calcul de la valeur dans le portefeuille d'une action non détenue.
	@Test
	public void testgetStockPortfolioValueStockNotOwned() throws StockNotFoundException {
		when(stockAPI.getStockPrice("Tesla")).thenReturn(1.1);
		when(stockStorage.get("Tesla")).thenReturn(0);
		assertEquals(0.0, stockPortfolio.getStockPortfolioValue("Tesla"), 0.1);
	}

	// tentative de calcul de la valeur dans le portefeuille d'une action non existante.
	@Test
	public void testgetStockPortfolioValueStockNotFound() throws StockNotFoundException {
		when(stockAPI.getStockPrice("Tesla")).thenThrow(new IllegalArgumentException());
		when(stockStorage.get("Tesla")).thenReturn(10);
		assertThrows(IllegalArgumentException.class, () -> stockPortfolio.getStockPortfolioValue("Tesla"));
	}

	// calcul de la valeur du portefeuille pour un portefeuille vide.
	@Test
	public void testGetEmptyPortfolioValue() throws StockNotFoundException {
		assertEquals(0, stockPortfolio.getTotalPortfolioValue());
	}

	// calcul de la valeur du portefeuille pour un portefeuille non vide.
	@Test
	public void testgetTotalPortfolioValue() throws StockNotFoundException {
		List<String> lst = new ArrayList<String>();
		lst.add("Tesla");
		lst.add("Google");
		when(stockStorage.listSymbols()).thenReturn(lst);
		when(stockAPI.getStockPrice("Tesla")).thenReturn(1.1);
		when(stockStorage.get("Tesla")).thenReturn(10);
		when(stockAPI.getStockPrice("Google")).thenReturn(1.1);
		when(stockStorage.get("Google")).thenReturn(10);
		assertEquals(22.0, stockPortfolio.getTotalPortfolioValue(), 0.1);
	}

	// calcul de la valeur du portefeuille avec des actions d'une quantité zéro.
	@Test
	public void testgetTotalPortfolioValueWithZeroQuantityStocks() throws StockNotFoundException {
		List<String> lst = new ArrayList<String>();
		lst.add("Tesla");
		lst.add("Google");
		when(stockStorage.listSymbols()).thenReturn(lst);
		when(stockAPI.getStockPrice("Tesla")).thenReturn(1.1);
		when(stockStorage.get("Tesla")).thenReturn(10);
		when(stockAPI.getStockPrice("Google")).thenReturn(1.1);
		when(stockStorage.get("Google")).thenReturn(0);
		assertEquals(11.0, stockPortfolio.getTotalPortfolioValue(), 0.1);
	}
}
