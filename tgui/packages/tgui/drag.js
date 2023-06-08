/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { storage } from 'common/storage';
import { vecAdd, vecInverse, vecMultiply, vecScale } from 'common/vector';
import { createLogger } from './logging';

const logger = createLogger('drag');

let windowKey = Byond.windowId;
let dragging = false;
let resizing = false;
let screenOffset = [0, 0];
let screenOffsetPromise;
let dragPointOffset;
let resizeMatrix;
let initialSize;
let size;

export const setWindowKey = (key) => {
  windowKey = key;
};

<<<<<<< HEAD
export const getWindowPosition = () => [
  window.screenLeft,
  window.screenTop,
];

export const getWindowSize = () => [
  window.innerWidth,
  window.innerHeight,
];

export const setWindowPosition = vec => {
=======
const getWindowPosition = () => [window.screenLeft * pixelRatio, window.screenTop * pixelRatio];

const getWindowSize = () => [window.innerWidth * pixelRatio, window.innerHeight * pixelRatio];

const setWindowPosition = (vec) => {
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  const byondPos = vecAdd(vec, screenOffset);
  return Byond.winset(Byond.windowId, {
    pos: byondPos[0] + ',' + byondPos[1],
  });
};

<<<<<<< HEAD
export const setWindowSize = vec => {
=======
const setWindowSize = (vec) => {
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  return Byond.winset(Byond.windowId, {
    size: vec[0] + 'x' + vec[1],
  });
};

<<<<<<< HEAD
export const getScreenPosition = () => [
  0 - screenOffset[0],
  0 - screenOffset[1],
];

export const getScreenSize = () => [
  window.screen.availWidth,
  window.screen.availHeight,
];
=======
const getScreenPosition = () => [0 - screenOffset[0], 0 - screenOffset[1]];

const getScreenSize = () => [window.screen.availWidth * pixelRatio, window.screen.availHeight * pixelRatio];
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))

/**
 * Moves an item to the top of the recents array, and keeps its length
 * limited to the number in `limit` argument.
 *
 * Uses a strict equality check for comparisons.
 *
 * Returns new recents and an item which was trimmed.
 */
const touchRecents = (recents, touchedItem, limit = 50) => {
  const nextRecents = [touchedItem];
  let trimmedItem;
  for (let i = 0; i < recents.length; i++) {
    const item = recents[i];
    if (item === touchedItem) {
      continue;
    }
    if (nextRecents.length < limit) {
      nextRecents.push(item);
    } else {
      trimmedItem = item;
    }
  }
  return [nextRecents, trimmedItem];
};

export const storeWindowGeometry = async () => {
  logger.log('storing geometry');
  const geometry = {
    pos: getWindowPosition(),
    size: getWindowSize(),
  };
  storage.set(windowKey, geometry);
  // Update the list of stored geometries
  const [geometries, trimmedKey] = touchRecents((await storage.get('geometries')) || [], windowKey);
  if (trimmedKey) {
    storage.remove(trimmedKey);
  }
  storage.set('geometries', geometries);
};

export const recallWindowGeometry = async (options = {}) => {
  // Only recall geometry in fancy mode
  const geometry = options.fancy && (await storage.get(windowKey));
  if (geometry) {
    logger.log('recalled geometry:', geometry);
  }
  let pos = geometry?.pos || options.pos;
  let size = options.size;
<<<<<<< HEAD
=======
  // Convert size from css-pixels to display-pixels
  if (size) {
    size = [size[0] * pixelRatio, size[1] * pixelRatio];
  }
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  // Wait until screen offset gets resolved
  await screenOffsetPromise;
  const areaAvailable = [
    window.screen.availWidth,
    window.screen.availHeight,
  ];
  // Set window size
  if (size) {
<<<<<<< HEAD
    // Constraint size to not exceed available screen area.
    size = [
      Math.min(areaAvailable[0], size[0]),
      Math.min(areaAvailable[1], size[1]),
    ];
=======
    // Constraint size to not exceed available screen area
    size = [Math.min(areaAvailable[0], size[0]), Math.min(areaAvailable[1], size[1])];
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
    setWindowSize(size);
  }
  // Set window position
  if (pos) {
    // Constraint window position if monitor lock was set in preferences.
    if (size && options.locked) {
      pos = constraintPosition(pos, size)[1];
    }
    setWindowPosition(pos);
  }
  // Set window position at the center of the screen.
  else if (size) {
    pos = vecAdd(vecScale(areaAvailable, 0.5), vecScale(size, -0.5), vecScale(screenOffset, -1.0));
    setWindowPosition(pos);
  }
};

export const setupDrag = async () => {
  // Calculate screen offset caused by the windows taskbar
  let windowPosition = getWindowPosition();

  screenOffsetPromise = Byond.winget(Byond.windowId, 'pos').then((pos) => [
    pos.x - windowPosition[0],
    pos.y - windowPosition[1],
  ]);
  screenOffset = await screenOffsetPromise;
  logger.debug('screen offset', screenOffset);
};

/**
 * Constraints window position to safe screen area, accounting for safe
 * margins which could be a system taskbar.
 */
const constraintPosition = (pos, size) => {
  const screenPos = getScreenPosition();
  const screenSize = getScreenSize();
  const nextPos = [pos[0], pos[1]];
  let relocated = false;
  for (let i = 0; i < 2; i++) {
    const leftBoundary = screenPos[i];
    const rightBoundary = screenPos[i] + screenSize[i];
    if (pos[i] < leftBoundary) {
      nextPos[i] = leftBoundary;
      relocated = true;
    } else if (pos[i] + size[i] > rightBoundary) {
      nextPos[i] = rightBoundary - size[i];
      relocated = true;
    }
  }
  return [relocated, nextPos];
};

export const dragStartHandler = (event) => {
  logger.log('drag start');
  dragging = true;
<<<<<<< HEAD
  dragPointOffset = [
    window.screenLeft - event.screenX,
    window.screenTop - event.screenY,
  ];
=======
  let windowPosition = getWindowPosition();
  dragPointOffset = vecSubtract([event.screenX, event.screenY], getWindowPosition());
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  // Focus click target
  event.target?.focus();
  document.addEventListener('mousemove', dragMoveHandler);
  document.addEventListener('mouseup', dragEndHandler);
  dragMoveHandler(event);
};

const dragEndHandler = (event) => {
  logger.log('drag end');
  dragMoveHandler(event);
  document.removeEventListener('mousemove', dragMoveHandler);
  document.removeEventListener('mouseup', dragEndHandler);
  dragging = false;
  storeWindowGeometry();
};

const dragMoveHandler = (event) => {
  if (!dragging) {
    return;
  }
  event.preventDefault();
<<<<<<< HEAD
  setWindowPosition(vecAdd(
    [event.screenX, event.screenY],
    dragPointOffset));
=======
  setWindowPosition(vecSubtract([event.screenX, event.screenY], dragPointOffset));
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
};

export const resizeStartHandler = (x, y) => (event) => {
  resizeMatrix = [x, y];
  logger.log('resize start', resizeMatrix);
  resizing = true;
<<<<<<< HEAD
  dragPointOffset = [
    window.screenLeft - event.screenX,
    window.screenTop - event.screenY,
  ];
  initialSize = [
    window.innerWidth,
    window.innerHeight,
  ];
=======
  dragPointOffset = vecSubtract([event.screenX, event.screenY], getWindowPosition());
  initialSize = getWindowSize();
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  // Focus click target
  event.target?.focus();
  document.addEventListener('mousemove', resizeMoveHandler);
  document.addEventListener('mouseup', resizeEndHandler);
  resizeMoveHandler(event);
};

const resizeEndHandler = (event) => {
  logger.log('resize end', size);
  resizeMoveHandler(event);
  document.removeEventListener('mousemove', resizeMoveHandler);
  document.removeEventListener('mouseup', resizeEndHandler);
  resizing = false;
  storeWindowGeometry();
};

const resizeMoveHandler = (event) => {
  if (!resizing) {
    return;
  }
  event.preventDefault();
<<<<<<< HEAD
  size = vecAdd(initialSize, vecMultiply(resizeMatrix, vecAdd(
    [event.screenX, event.screenY],
    vecInverse([window.screenLeft, window.screenTop]),
    dragPointOffset,
    [1, 1])));
=======
  const currentOffset = vecSubtract([event.screenX, event.screenY], getWindowPosition());
  const delta = vecSubtract(currentOffset, dragPointOffset);
  // Extra 1x1 area is added to ensure the browser can see the cursor
  size = vecAdd(initialSize, vecMultiply(resizeMatrix, delta), [1, 1]);
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  // Sane window size values
  size[0] = Math.max(size[0], 150);
  size[1] = Math.max(size[1], 50);
  setWindowSize(size);
};
