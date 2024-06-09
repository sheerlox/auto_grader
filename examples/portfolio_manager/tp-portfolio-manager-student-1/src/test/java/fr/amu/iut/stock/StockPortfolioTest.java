package fr.amu.iut.stock;

import java.util.Arrays;

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
	public void testAddNewStock() {
		stockPortfolio.addStockQuantity("amazon", 10);
		verify(stockStorage, times(1)).put("amazon", 10);
	}

	// ajout d'une quantité d'actions pour une action déjà détenue.
	@Test
	public void testAddStockQuantity() {
		when(stockStorage.listSymbols()).thenReturn(Arrays.asList("amazon"));
		when(stockStorage.get("amazon")).thenReturn(10);
		stockPortfolio.addStockQuantity("amazon", 10);
		verify(stockStorage, times(1)).put(eq("amazon"), eq(20));
	}

	// tentative d'ajout d'une quantité d'actions négative.
	@Test
	public void testAddNegativeStockQuantity() {
		assertThrows(IllegalArgumentException.class, () -> stockPortfolio.addStockQuantity("amazon", -10));
	}

	// suppression d'une quantité d'actions pour une action déjà détenue.
	@Test
	public void testRemoveStockQuantity() throws NotEnoughStockQuantityException {
		when(stockStorage.listSymbols()).thenReturn(Arrays.asList("amazon"));
		when(stockStorage.get("amazon")).thenReturn(10);
		stockPortfolio.removeStockQuantity("amazon", 10);
		verify(stockStorage, times(1)).put(eq("amazon"), eq(0));
	}

	// tentative de suppression d'une quantité d'actions négative.
	@Test
	public void testRemoveNegativeStockQuantity() throws NotEnoughStockQuantityException {
		assertThrows(IllegalArgumentException.class, () -> stockPortfolio.removeStockQuantity("amazon", -10));
	}

	// tentative de suppression d'une quantité d'actions trop importante.
	@Test
	public void testRemoveTooMuchStockQuantity() {
		fail("Not implemented");
	}

	// tentative de suppression d'une quantité d'actions pour une action non détenue.
		@Test
		public void testRemoveStockQuantityStockNotOwned() {
			when(stockStorage.listSymbols()).thenReturn(Arrays.asList("amazon"));
			assertThrows(NotEnoughStockQuantityException.class, () -> stockPortfolio.removeStockQuantity("apple", 10));
		}

	// calcul de la valeur dans le portefeuille d'une action existante.
	@Test
	public void testgetStockPortfolioValue() throws StockNotFoundException {
		when(stockStorage.listSymbols()).thenReturn(Arrays.asList("amazon"));
		when(stockStorage.get("amazon")).thenReturn(10);
		when(stockAPI.getStockPrice("amazon")).thenReturn(3.0);
		assertEquals(30.0, stockPortfolio.getStockPortfolioValue("amazon"));
		
	}

	// calcul de la valeur dans le portefeuille d'une action non détenue.
	@Test
	public void testgetStockPortfolioValueStockNotOwned() throws StockNotFoundException {
		when(stockStorage.listSymbols()).thenReturn(Arrays.asList("apple"));
		when(stockStorage.get("apple")).thenReturn(10);
		when(stockAPI.getStockPrice("amazon")).thenReturn(3.0);
		assertEquals(20, stockPortfolio.getStockPortfolioValue("apple"));
	}

	// tentative de calcul de la valeur dans le portefeuille d'une action non existante.
	@Test
	public void testgetStockPortfolioValueStockNotFound() throws StockNotFoundException {
		fail("Not implemented");
	}

	// calcul de la valeur du portefeuille pour un portefeuille vide.
	@Test
	public void testGetEmptyPortfolioValue() throws StockNotFoundException {
		fail("Not implemented");
	}

	// calcul de la valeur du portefeuille pour un portefeuille non vide.
	@Test
	public void testgetTotalPortfolioValue() throws StockNotFoundException {
		fail("Not implemented");
	}

	// calcul de la valeur du portefeuille avec des actions d'une quantité zéro.
	@Test
	public void testgetTotalPortfolioValueWithZeroQuantityStocks() throws StockNotFoundException {
		fail("Not implemented");
	}
}
