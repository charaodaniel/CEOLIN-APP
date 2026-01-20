/**
 * @OnlyCurrentDoc
 * Este script cria um Web App que funciona como uma API para o aplicativo Flutter.
 * Ele recebe uma lista de corridas em formato JSON e a espelha na planilha.
 */

// Função principal que executa quando o app Flutter envia dados via POST.
function doPost(e) {
  try {
    // 1. Acessa a planilha ativa e a aba (página) específica.
    // !! ATENÇÃO !! Mude 'Página1' se o nome da sua aba for diferente.
    const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Página1');
    if (!sheet) {
      throw new Error("Aba 'Página1' não encontrada. Verifique o nome da aba na sua planilha.");
    }
    
    // 2. Analisa o conteúdo da requisição (os dados JSON enviados pelo Flutter).
    const data = JSON.parse(e.postData.contents);

    // 3. Limpa completamente a planilha para garantir que os dados sejam um espelho.
    sheet.clear();

    // 4. Define e escreve o cabeçalho das colunas.
    const headers = ['Destino', 'Data e Hora', 'Valor (R$)'];
    sheet.getRange(1, 1, 1, headers.length)
         .setValues([headers])
         .setFontWeight('bold')
         .setHorizontalAlignment('center');

    // 5. Verifica se há dados para processar.
    if (!data || data.length === 0) {
      // Se não houver dados, apenas confirma que a planilha foi limpa.
      return ContentService
        .createTextOutput(JSON.stringify({ status: 'success', message: 'Planilha limpa. Nenhum dado para sincronizar.' }))
        .setMimeType(ContentService.MimeType.JSON);
    }

    // 6. Mapeia os dados recebidos para o formato de linhas da planilha.
    const rows = data.map(ride => {
      const dateObject = new Date(ride.date);
      const fare = parseFloat(ride.fare) || 0;
      return [ride.destination, dateObject, fare];
    });

    // 7. Insere todas as linhas de uma vez para máxima eficiência.
    sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
    
    // 8. Formata as colunas de data e valor para melhor visualização.
    sheet.getRange(2, 2, rows.length, 1).setNumberFormat('dd/mm/yyyy hh:mm:ss');
    sheet.getRange(2, 3, rows.length, 1).setNumberFormat('R$ #,##0.00');
    
    // 9. Ajusta a largura das colunas automaticamente ao conteúdo.
    sheet.autoResizeColumns(1, headers.length);

    // 10. Retorna uma resposta de sucesso para o aplicativo Flutter.
    return ContentService
      .createTextOutput(JSON.stringify({ status: 'success', message: 'Dados sincronizados com sucesso!' }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    // 11. Em caso de qualquer erro, registra o erro e retorna uma mensagem para o Flutter.
    Logger.log(error.toString());
    return ContentService
      .createTextOutput(JSON.stringify({ status: 'error', message: error.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
