/*
This network can only be used once
Propagators are run in an arbitrary, unpredictable order. This is important because we don’t want to accidentally depend on the order of their execution.
Once a propagator is run, by default it will not run again unless it gets queued again.
Every propagator that is queued will eventually run.
*/

/**
 * A Cell does not have any removeContent or alterContent methods. That is on purpose.
 * Cells hold state and a list of every propagator watching them.
 * When the cell’s state changes, it notifies all the propagators.
 */
class Cell {
    #content: unknown = undefined;
    #neighbors: Cell[] = [];

    /**
     * Extracts the cell's current content
     */
    get content(): unknown {
        return this.#content;
    }

    get neighbors(): Cell[] {
        return [...this.#neighbors];
    }

    /**
     * Adds some content to the cell
     */
    addContent(increment: unknown): void {
        if (increment === undefined) {
            return;
        }

        if (this.content === undefined) {
            this.#content = increment;
            this.#alertPropagators();
        } else if (this.content !== increment) {
            throw new Error("Ack! Inconsistency!");
        }
    }

    #alertPropagators(): void {
        throw new Error("Method not implemented.");
    }

    #alertPropagator(cell: Cell) {
        throw new Error("Method not implemented.");
    }

    /**
     * Asserts that a propagator should be queued when the cell's content changes
     */
    newNeighbor(neighbor: Cell): void {
        if (!this.neighbors.includes(neighbor)) {
            this.neighbors.push(neighbor);
            this.#alertPropagator(neighbor);
        }
    }
}

function propagator(neighbors: Cell[], toDo: Cell) {
    neighbors.forEach((cell) => {
        cell.newNeighbor(toDo);
    });
}

let fahrenheitCell = new Cell();
let celsiusCell = new Cell();
fahrenheitToCelsius(fahrenheitCell, celsiusCell);
fahrenheitCell.addContent(77); // 77 will never be forgotten by the cell
console.log(celsiusCell.content);

function fahrenheitToCelsius(fahrenheitCell: Cell, celsiusCell: Cell) {
    let thirtyTwo = new Cell();
    let f32 = new Cell();
    let five = new Cell();
    let cTimes9 = new Cell();
    let nine = new Cell();
    constant(thirtyTwo, 32);
    constant(five, 5);
    constant(nine, 9);
    subtractor(fahrenheitCell, thirtyTwo, f32);
    multiplier(f32, five, cTimes9);
    divider(cTimes9, nine, celsiusCell);
}

function constant(cell: Cell, value: any) {
    cell.addContent(value);
}

function adder(a: unknown, b: unknown, c: unknown) {
    // TODO
}

function subtractor(a: unknown, b: unknown, c: unknown) {
    // TODO
}

function multiplier(a: unknown, b: unknown, c: unknown) {
    // TODO
}

function divider(a: unknown, b: unknown, c: unknown) {
    // TODO
}
