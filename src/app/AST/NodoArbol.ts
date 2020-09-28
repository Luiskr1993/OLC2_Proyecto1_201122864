
export class NodoArbol {
    public id: string;
    public valor: string;
    public hijos: NodoArbol[];
    constructor(nuevoId: string, nuevoValor: string) {
        this.id = nuevoId;
        this.valor = nuevoValor;
        this.hijos = null;
    }
    public insertaHijo(id: string, valor: string): void {
        let nuevoNodo: NodoArbol;
        nuevoNodo = new NodoArbol(id, valor);
        if (nuevoNodo != null) {
            this.hijos.push(nuevoNodo);
        } else {
            console.log('[Error]: No se especificaron valores para crear el nuevo Nodo del Arbol...');
        }
    }
}
