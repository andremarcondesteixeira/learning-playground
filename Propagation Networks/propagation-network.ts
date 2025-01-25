/*
This network can only be used once
Propagators are run in an arbitrary, unpredictable order. This is important because we don’t want to accidentally depend on the order of their execution.
Once a propagator is run, by default it will not run again unless it gets queued again.
Every propagator that is queued will eventually run.
*/

let f = makeCell();
let c = makeCell();
fahrenheitToCelsius(f, c);
addContent(f, 77); // 77 will never be forgotten by the cell
content(c);

function fahrenheitToCelsius(f, c) {
    let thirtyTwo = makeCell();
    let f32 = makeCell();
    let five = makeCell();
    let cTimes9 = makeCell();
    let nine = makeCell();
    constant(thirtyTwo, 32);
    constant(five, 5);
    constant(nine, 9);
    subtractor(f, thirtyTwo, f32);
    multiplier(f32, five, cTimes9);
    divider(cTimes9, nine, c);
}

function makeCell(): Cell {
    return new Cell();
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

/**
 * A Cell does not have any removeContent or alterContent methods. That is on purpose.
 * Cells hold state and a list of every propagator watching them.
 * When the cell’s state changes, it notifies all the propagators.
 */
class Cell {
    #content: any;

    constructor() {
        // TODO
    }

    /**
     * Extracts the cell's current content
     */
    get content() {
        return this.#content;
    }

    /**
     * Adds some content to the cell
     */
    addContent(value: any) {
        // TODO
    }

    /**
     * Asserts that a propagator should be queued when the cell's content changes
     */
    newNeighbor(neighbor: unknown) {
        // TODO
    }

}
