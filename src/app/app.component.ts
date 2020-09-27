import { Component } from '@angular/core';
import { Gramatica } from './grammar/grammar.js';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'MatrioshTS';
  sayHello(): void{
    alert('hola');
  }

  leerCadenaEntrada(): void{
    const analizador = new Gramatica();
    let consola =  (document.getElementById('textConsola') as HTMLInputElement).value;
    consola += '[Proc]:Leyendo código de entrada... \n';

    const contenido = (document.getElementById('textAreaCodigo') as HTMLInputElement).value;
    if ( contenido === ''){
        consola += '[ERROR]:No se encontró código válido para traducir. \n';
        (document.getElementById('textConsola') as HTMLInputElement).value = consola ;
    }
    else {
      consola += '[Proc]:Código reconocido... \n';
      consola += '[COD]: ';
      consola += contenido;
      consola += '\n';
      const respuesta = analizador.parse(contenido);
      consola += '[Analizador]: ';
      consola += respuesta + '\n';
      (document.getElementById('textAreaProcesado') as HTMLInputElement).value = contenido ;
      (document.getElementById('textConsola') as HTMLInputElement).value = consola ;
    }
  }

  ejecutarCodigoTraducido(): void{
    const contenido = (document.getElementById('textAreaProcesado') as HTMLInputElement).value;
    let consola =  (document.getElementById('textConsola') as HTMLInputElement).value;
    consola = '';
    if ( contenido === ''){
      consola += '[ERROR]:No existe código para ejecutar \n';
      (document.getElementById('textConsola') as HTMLInputElement).value = consola ;
    }else{
      consola += '[Proc]:Leyendo código... \n';
      consola += '[Proc]:Generando ejecución de código... \n';
      consola += '[Proc]:Código ejecutado correctamente. \n';
      (document.getElementById('textConsola') as HTMLInputElement).value = consola ;
    }
  }
}

