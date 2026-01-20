/**
 * @OnlyCurrentDoc
 * Este script cria um Web App que funciona como uma API para o aplicativo Flutter.
 * Ele recebe uma lista de corridas em formato JSON e a espelha na planilha.
 */

// Função principal que executa quando o app Flutter envia dados via POST.
function doPost(e) {
  try {
    // Verifica se a função foi acionada sem dados, como ao ser executada manualmente.
    if (!e || !e.postData || !e.postData.contents) {
      throw new Error("Dados não recebidos. Esta função deve ser acionada por um POST request do aplicativo.");
    }

    const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Página1');
    if (!sheet) {
      throw new Error("Aba 'Página1' não encontrada. Verifique o nome da aba na sua planilha.");
    }
    
    const data = JSON.parse(e.postData.contents);

    // Garante que os dados são um array antes de continuar
    if (!Array.isArray(data)) {
        throw new Error("O formato dos dados recebidos não é uma lista (array).");
    }

    // Se não houver dados, não faz nada.
    if (data.length === 0) {
        return ContentService.createTextOutput(JSON.stringify({'status': 'success', 'message': 'Nenhum dado para sincronizar.'})).setMimeType(ContentService.MimeType.JSON);
    }

    sheet.clear(); // Limpa a planilha para espelhar os novos dados

    // Cria os cabeçalhos dinamicamente a partir do primeiro item
    const headers = Object.keys(data[0]);
    sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold');

    // Mapeia os dados para o formato de linhas da planilha
    const rows = data.map(rowObject => headers.map(header => rowObject[header] || ""));

    // Escreve os dados na planilha
    sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
    sheet.autoResizeColumns(1, headers.length);

    return ContentService.createTextOutput(JSON.stringify({'status': 'success', 'message': 'Planilha sincronizada!'})).setMimeType(ContentService.MimeType.JSON);

  } catch (err) {
    // Retorna uma resposta de erro claro para o app
    return ContentService.createTextOutput(JSON.stringify({'status': 'error', 'message': err.toString()})).setMimeType(ContentService.MimeType.JSON);
  }
}

/**
 * Esta função é um utilitário para popular a planilha inteira a partir de um objeto JSON.
 * Ela deve ser executada manualmente pelo editor do Apps Script sempre que você quiser
 * recriar a planilha a partir do JSON base.
 */
function popularPlanilhaPeloJson() {
  const spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  
  // !! ATENÇÃO !! COLE O CONTEÚDO COMPLETO DO SEU 'banco.json' AQUI DENTRO
  const jsonData = {
    // O JSON entra aqui
  };

  // Itera sobre cada chave do JSON (ex: "users", "rides").
  for (const tableName in jsonData) {
    if (!jsonData.hasOwnProperty(tableName)) continue;

    const tableData = jsonData[tableName];
    if (!tableData || !Array.isArray(tableData) || tableData.length === 0) continue;

    let sheet = spreadsheet.getSheetByName(tableName);
    if (sheet) {
      sheet.clear();
    } else {
      sheet = spreadsheet.insertSheet(tableName);
    }

    const headers = Object.keys(tableData[0]);
    sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold');

    const rows = tableData.map(obj => {
      return headers.map(header => {
        const value = obj[header];
        if (value === null || value === undefined) return "";
        if (Array.isArray(value)) return value.join(', '); // Converte arrays para string
        if (typeof value === 'object') return JSON.stringify(value); // Converte objetos para string
        return value;
      });
    });

    sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
    sheet.autoResizeColumns(1, headers.length);
  }
}
