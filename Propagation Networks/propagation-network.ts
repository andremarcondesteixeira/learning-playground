/*
This network can only be used once
Propagators are run in an arbitrary, unpredictable order. This is important because we don’t want to accidentally depend on the order of their execution.
Once a propagator is run, by default it will not run again unless it gets queued again.
Every propagator that is queued will eventually run.
*/

class Propagator {

}

/**
 * A Cell does not have any removeContent or alterContent methods. That is on purpose.
 * Cells hold state and a list of every propagator watching them.
 * When the cell’s state changes, it notifies all the propagators.
 */
class Cell {
    #content: unknown[] = [undefined];
    #neighbors: Propagator[] = [];

    /**
     * Extracts the cell's current content
     */
    get content(): unknown {
        return this.#content[this.#content.length - 1];
    }

    get neighbors(): Propagator[] {
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
            this.#content.push(increment);
            this.#alertPropagators();
        } else if (this.content !== increment) {
            throw new Error("Ack! Inconsistency!");
        }
    }

    #alertPropagators(): void {
        throw new Error("Method not implemented.");
    }

    #alertPropagator(neighbor: Propagator) {
        throw new Error("Method not implemented.");
    }

    /**
     * Asserts that a propagator should be queued when the cell's content changes
     */
    addNeighbor(neighbor: Propagator): void {
        if (!this.neighbors.includes(neighbor)) {
            this.neighbors.push(neighbor);
            this.#alertPropagator(neighbor);
        }
    }
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

function subtractor(a, b, c) {
    // TODO
}

function multiplier(a, b, c) {
    // TODO
}

function divider(a, b, c) {
    // TODO
}
