import styled, { css } from 'styled-components';

export const Wrapper = styled.div<{ $isFetching: boolean }>`
  position: relative;

  ${({ $isFetching }) =>
    $isFetching &&
    css`
      & > *:not(:last-child) {
        opacity: 0.5;
        pointer-events: none;
      }
    `}
`;

export const Overlay = styled.div`
  position: absolute;
  inset: 0;
  display: flex;
  justify-content: center;
  padding-top: 80px;
  z-index: 10;
`;
