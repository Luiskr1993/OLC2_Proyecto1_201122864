import { Token } from './Token';
import { Component } from '@angular/core';
import { tokenName } from '@angular/compiler';
import { isNumber } from 'util';


export class ApptablaSimbolos {
    title = 'tablaSimbolos';
    public primero: Token;
    public ultimo: Token;
    constructor(){
        this.primero = null;
        this.ultimo = null;
    }
    public estaVacia(): boolean{
        return this.primero === null;
    }
    public totalElementos(): number{
        if (this.estaVacia()){
            return 0; // no hay elementos en la lista entonces retorna cero
        } else {
            let i = 0;
            let temp = this.primero;
            while (temp) {
                i++;
                temp = temp.siguiente;
            }
            return i;
        }
    }
    public insertaTokenInicio(token: Token): void{
        if (token) {
            if (this.estaVacia()) {
                this.primero = new Token(token.simbolo, token.tipo, token.posicion);
                this.ultimo = this.primero;
            } else {
                const temp = new Token(token.simbolo, token.tipo, token.posicion);
                temp.siguiente = this.primero;
                this.primero.anterior = temp;
                this.primero = temp;
            }
        }
    }
    public insertaTokenFinal(token: Token): void{
        if (token) {
            if (this.estaVacia()) {
                this.primero = new Token(token.simbolo, token.tipo, token.posicion);
                this.ultimo = this.primero;
            } else {
                const temp = new Token(token.simbolo, token.tipo, token.posicion);
                const temp2 = this.ultimo;
                temp2.siguiente = temp;
                temp.anterior = temp2;
                this.ultimo = temp;
            }
        }
    }
    public eliminaPrimero(): void{
        if (!this.estaVacia()) {
            const temp = this.primero;
            this.primero = temp.siguiente;
            temp.siguiente = null;
            temp.anterior = null;
        }
    }
    public eliminaUltimo(): void{
        if (!this.estaVacia()) {
            const temp = this.ultimo.anterior;
            temp.siguiente = null;
            this.ultimo.anterior = null;
            this.ultimo.siguiente = null;
            this.ultimo = temp;
        }
    }
    public eliminaToken(simbolo: string): void{
        if (!this.estaVacia()) {
            const totalTokens = this.totalElementos();
            let i: number;
            i = 0;
            let temp: Token;
            temp = this.primero;
            while (i < totalTokens) {
                if (temp.simbolo !== simbolo) {
                    temp = temp.siguiente;
                    i++;
                } else {
                    i = totalTokens;
                }
            }
            let temp0: Token;
            let temp1: Token;
            if (temp === this.primero) {
                this.eliminaPrimero();
            } else if (temp === this.ultimo) {
                this.eliminaUltimo();
            } else {
                if (temp.siguiente){
                    if (temp.anterior){
                        temp0 = temp.anterior;
                        temp1 = temp.siguiente;
                        temp0.siguiente = temp1;
                        temp1.anterior = temp0;
                    }
                }
            }
        }
    }
    public buscaToken(simbolo: string): boolean{
        let respuesta: boolean;
        if (this.estaVacia()) {
            respuesta = false;
        } else {
            if (simbolo === this.primero.simbolo) {
                respuesta = true;
            } else if (simbolo === this.ultimo.simbolo) {
                respuesta = true;
            } else {
                let temp: Token;
                temp = this.primero;
                let i: number;
                let total: number;
                i = 0;
                total = this.totalElementos();
                for  (i === 1; i < total; i++) {
                    if (simbolo === temp.simbolo) {
                        respuesta = true;
                        i = total + 1;
                    } else {
                        if (temp !== this.ultimo) {
                            temp = temp.siguiente;
                        } else {
                            respuesta = false;
                        }
                    }
                }
            }
        }
        return respuesta;
    }
}
