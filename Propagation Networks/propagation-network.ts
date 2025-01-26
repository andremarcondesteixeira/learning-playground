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
    #content: any[] = [undefined];
    #neighbors: unknown[] = [];

    /**
     * Extracts the cell's current content
     */
    get content() {
        return this.#content[this.#content.length - 1];
    }

    get neighbors() {
        return [...this.#neighbors];
    }

    /**
     * Adds some content to the cell
     */
    addContent(value: any) {
        this.#content.push(value);
    }

    /**
     * Asserts that a propagator should be queued when the cell's content changes
     */
    newNeighbor(neighbor: unknown) {
        this.#neighbors.push(neighbor);
    }
}

let fahrenheitCell = new Cell();
let celsiusCell = new Cell();
fahrenheitToCelsius(fahrenheitCell, celsiusCell);
fahrenheitCell.addContent(77); // 77 will never be forgotten by the cell
const content = celsiusCell.content();
console.log(content);

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
