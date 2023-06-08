/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { canRender, classes } from 'common/react';
import { computeBoxClassName, computeBoxProps } from './Box';
import { Icon } from './Icon';

<<<<<<< HEAD
export const Tabs = props => {
  const {
    className,
    vertical,
    fluid,
    children,
    ...rest
  } = props;
=======
export const Tabs = (props) => {
  const { className, vertical, fill, fluid, children, ...rest } = props;
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  return (
    <div
      className={classes([
        'Tabs',
<<<<<<< HEAD
        vertical
          ? 'Tabs--vertical'
          : 'Tabs--horizontal',
=======
        vertical ? 'Tabs--vertical' : 'Tabs--horizontal',
        fill && 'Tabs--fill',
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
        fluid && 'Tabs--fluid',
        className,
        computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {children}
    </div>
  );
};

const Tab = (props) => {
  const { className, selected, color, icon, leftSlot, rightSlot, children, ...rest } = props;
  return (
    <div
      className={classes([
        'Tab',
        'Tabs__Tab',
        'Tab--color--' + color,
        selected && 'Tab--selected',
        className,
        ...computeBoxClassName(rest),
      ])}
      {...computeBoxProps(rest)}>
      {(canRender(leftSlot) && <div className="Tab__left">{leftSlot}</div>) ||
        (!!icon && (
          <div className="Tab__left">
            <Icon name={icon} />
          </div>
        ))}
      <div className="Tab__text">{children}</div>
      {canRender(rightSlot) && <div className="Tab__right">{rightSlot}</div>}
    </div>
  );
};

Tabs.Tab = Tab;
