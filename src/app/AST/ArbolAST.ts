import { NodoArbol } from './NodoArbol';
import { Component } from '@angular/core';
import { tokenName } from '@angular/compiler';
import { isNumber } from 'util';

export class ArbolAST{
    public raiz: NodoArbol;
    public totalNodos: number;
    constructor(){
        this.raiz = null;
        this.totalNodos = 0;
    }
    public NewNodo(id: string, valor: string, NodoPadre: NodoArbol): void{
        let nodo: NodoArbol;
        nodo = new NodoArbol(id, valor);
        if (this.totalNodos === 0 ){
            this.raiz = nodo;
        } else {
            this.totalNodos++;
            this.raiz.insertaHijo(nodo.id, nodo.valor);
        }
    }
}
