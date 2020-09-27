
export class Token {
      public simbolo: string;
      public tipo: string;
      public posicion: number;
      public siguiente: Token;
      public anterior: Token;
      constructor(nuevosimbolo: string, nuevotipo: string, nuevaposicion: number){
          this.simbolo = nuevosimbolo;
          this.tipo = nuevotipo;
          this.posicion = nuevaposicion;
          this.siguiente = null;
          this.anterior = null;
      }
  }
