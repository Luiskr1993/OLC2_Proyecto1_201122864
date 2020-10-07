
export class NodoArbol {
    public id: number;
    public valor: string;
    public hijos: NodoArbol[];
    constructor(nuevoId: number, nuevoValor: string) {
        this.id = nuevoId;
        this.valor = nuevoValor;
        this.hijos = [];
    }
    public insertaHijo(id: number, valor: string): void {
        let nuevoNodo: NodoArbol;
        nuevoNodo = new NodoArbol(id, valor);
        if (nuevoNodo != null) {
            this.hijos.push(nuevoNodo);
        } else {
            console.log('[Error]: No se especificaron valores para crear el nuevo Nodo del Arbol...');
        }
    }
}
